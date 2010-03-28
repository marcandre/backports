# Methods used internally by the backports.

module Backports
  # Adapted from Pragmatic's "Programming Ruby" (since their version was buggy...)
  def self.require_relative(relative_feature)
    file = caller.first.split(/:\d/,2).first
    if /\A\((.*)\)/ =~ file # eval, etc.
      raise LoadError, "require_relative is called in #{$1}"
    end
    require File.expand_path(relative_feature, File.dirname(file))
  end

  def self.require_relative_dir(relative_dir)
    dir = File.expand_path(relative_dir, File.dirname(caller.first.split(/:\d/,2).first))
    Dir.entries(dir).
        map{|f| Regexp.last_match(1) if /^(.*)\.rb$/ =~ f}.
        compact.
        sort.
        each do |f|
          require File.expand_path(f, dir)
        end
  end

  # Metaprogramming utility to make block optional.
  # Tests first if block is already optional when given options
  def self.make_block_optional mod,*methods
    options = methods.last.is_a?(Hash) ? methods.pop : {}
    methods.each do |selector|
      unless mod.method_defined? selector
        warn "#{mod}##{selector} is not defined, so block can't be made optional"
        next
      end
      unless options.empty?
        test_on = options[:test_on] || self.new
        next if (test_on.send(selector, *options.fetch(:arg, [])) rescue false)
      end

      arity = mod.instance_method(selector).arity
      last_arg = []
      if arity < 0
        last_arg = ["*rest"]
        arity = -1-arity
      end
      arg_sequence = ((0...arity).map{|i| "arg_#{i}"} + last_arg + ["&block"]).join(", ")

      alias_method_chain(mod, selector, :optional_block) do |aliased_target, punctuation|
        mod.module_eval <<-end_eval
          def #{aliased_target}_with_optional_block#{punctuation}(#{arg_sequence})
            return to_enum(:#{aliased_target}_without_optional_block#{punctuation}, #{arg_sequence}) unless block_given?
            #{aliased_target}_without_optional_block#{punctuation}(#{arg_sequence})
          end
        end_eval
      end
    end
  end

  # Metaprogramming utility to convert the first file argument to path
  def self.convert_first_argument_to_path mod,*methods
    methods.each do |selector|
      unless mod.method_defined? selector
        warn "#{mod}##{selector} is not defined, so argument can't converted to path"
        next
      end
      arity = mod.instance_method(selector).arity
      last_arg = []
      if arity < 0
        last_arg = ["*rest"]
        arity = -1-arity
      end
      arg_sequence = (["file"] + (1...arity).map{|i| "arg_#{i}"} + last_arg + ["&block"]).join(", ")

      alias_method_chain(mod, selector, :potential_path_argument) do |aliased_target, punctuation|
        mod.module_eval <<-end_eval
          def #{aliased_target}_with_potential_path_argument#{punctuation}(#{arg_sequence})
            file = Backports.convert_to_path(file)
            #{aliased_target}_without_potential_path_argument#{punctuation}(#{arg_sequence})
          end
        end_eval
      end
    end
  end

  # Metaprogramming utility to convert all file arguments to paths
  def self.convert_all_arguments_to_path mod, skip, *methods
    methods.each do |selector|
      unless mod.method_defined? selector
        warn "#{mod}##{selector} is not defined, so arguments can't converted to path"
        next
      end
      first_args = (1..skip).map{|i| "arg_#{i}"}.join(",") + (skip > 0 ? "," : "")
      alias_method_chain(mod, selector, :potential_path_arguments) do |aliased_target, punctuation|
        mod.module_eval <<-end_eval
          def #{aliased_target}_with_potential_path_arguments#{punctuation}(#{first_args}*files, &block)
            files = files.map{|f| Backports.convert_to_path f}
            #{aliased_target}_without_potential_path_arguments#{punctuation}(#{first_args}*files, &block)
          end
        end_eval
      end
    end
  end

  def self.convert_to_path(file_or_path)
    coerce_to(file_or_path, String, :to_str) rescue coerce_to(file_or_path, String, :to_path) rescue file_or_path
  end

  # Modified to avoid polluting Module if so desired
  # (from Rails)
  def self.alias_method_chain(mod, target, feature)
    mod.class_eval do
      # Strip out punctuation on predicates or bang methods since
      # e.g. target?_without_feature is not a valid method name.
      aliased_target, punctuation = target.to_s.sub(/([?!=])$/, ''), $1
      yield(aliased_target, punctuation) if block_given?

      with_method, without_method = "#{aliased_target}_with_#{feature}#{punctuation}", "#{aliased_target}_without_#{feature}#{punctuation}"

      alias_method without_method, target
      alias_method target, with_method

      case
        when public_method_defined?(without_method)
          public target
        when protected_method_defined?(without_method)
          protected target
        when private_method_defined?(without_method)
          private target
      end
    end
  end

  # Helper method to coerce a value into a specific class.
  # Raises a TypeError if the coercion fails or the returned value
  # is not of the right class.
  # (from Rubinius)
  def self.coerce_to(obj, cls, meth)
    return obj if obj.kind_of?(cls)

    begin
      ret = obj.__send__(meth)
    rescue Exception => e
      raise TypeError, "Coercion error: #{obj.inspect}.#{meth} => #{cls} failed:\n" \
                       "(#{e.message})"
    end
    raise TypeError, "Coercion error: obj.#{meth} did NOT return a #{cls} (was #{ret.class})" unless ret.kind_of? cls
    ret
  end

  def self.coerce_to_int(obj)
    coerce_to(obj, Integer, :to_int)
  end

  def self.coerce_to_ary(obj)
    coerce_to(obj, Array, :to_ary)
  end

  # Checks for a failed comparison (in which case it throws an ArgumentError)
  # Additionally, it maps any negative value to -1 and any positive value to +1
  # (from Rubinius)
  def self.coerce_to_comparison(a, b, cmp = (a <=> b))
    raise ArgumentError, "comparison of #{a} with #{b} failed" if cmp.nil?
    return 1 if cmp > 0
    return -1 if cmp < 0
    0
  end

  # Used internally to make it easy to deal with optional arguments
  # (from Rubinius)
  Undefined = Object.new

  # Used internally.
  # Safe alias_method that will only alias if the source exists and destination doesn't
  def self.alias_method(mod, new_name, old_name)
    mod.class_eval do
      alias_method new_name, old_name if method_defined?(old_name) and not method_defined?(new_name)
    end
  end

  # A simple class which allows the construction of Enumerator from a block
  class Yielder
    def initialize(&block)
      @main_block = block
    end

    def each(&block)
      @final_block = block
      @main_block.call(self)
    end

    def yield(*arg)
      @final_block.yield(*arg)
    end
  end
end
