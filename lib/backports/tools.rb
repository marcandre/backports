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

  module StdLib
    class LoadedFeatures
      if RUBY_VERSION >= "1.9"
        # Full paths are recorded in $LOADED_FEATURES.
        def initialize
          # Assume backported features are Ruby libraries (i.e. not C)
          @loaded = $LOADED_FEATURES.group_by{|p| File.basename(p, ".rb")}
        end

        # Check loaded features for one that matches "#{any of the load path}/#{feature}"
        def include?(feature)
          if fullpaths = @loaded[File.basename(feature, ".rb")]
            fullpaths.any?{|fullpath|
              base_dir, = fullpath.partition("/#{feature}")
              $LOAD_PATH.include?(base_dir)
            }
          end
        end

        def self.mark_as_loaded(feature)
          # Nothing to do, the full path will be OK
        end

      else
        # Requested features are recorded in $LOADED_FEATURES
        def include?(feature)
          # Assume backported features are Ruby libraries (i.e. not C)
          $LOADED_FEATURES.include?("#{File.basename(feature, '.rb')}.rb")
        end

        def self.mark_as_loaded(feature)
          $LOADED_FEATURES << "#{File.basename(feature, '.rb')}.rb"
        end
      end
    end

    class << self
      attr_accessor :extended_lib

      def extend_relative relative_dir="stdlib"
        loaded = Backports::StdLib::LoadedFeatures.new
        dir = File.expand_path(relative_dir, File.dirname(caller.first.split(/:\d/,2).first))
        Dir.entries(dir).
          map{|f| Regexp.last_match(1) if /^(.*)\.rb$/ =~ f}.
          compact.
          each do |f|
            path = File.expand_path(f, dir)
            if loaded.include?(f)
              require path
            else
              @extended_lib[f] << path
            end
          end
      end
    end
    self.extended_lib ||= Hash.new{|h, k| h[k] = []}
  end

  # Metaprogramming utility to make block optional.
  # Tests first if block is already optional when given options
  def self.make_block_optional(mod, *methods)
    options = methods.last.is_a?(Hash) ? methods.pop : {}
    methods.each do |selector|
      unless mod.method_defined? selector
        warn "#{mod}##{selector} is not defined, so block can't be made optional"
        next
      end
      unless options[:force]
        # Check if needed
        test_on = options.fetch(:test_on)
        result =  begin
                    test_on.send(selector, *options.fetch(:arg, []))
                  rescue LocalJumpError
                    false
                  end
        next if result.class.name =~ /Enumerator$/
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
  def self.convert_first_argument_to_path(mod, *methods)
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
  def self.convert_all_arguments_to_path(mod, skip, *methods)
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
    file_or_path.respond_to?(:to_path) ? file_or_path.to_path  : file_or_path
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

  def self.coerce_to_str(obj)
    coerce_to(obj, String, :to_str)
  end

  def self.try_convert(obj, cls, meth)
    return obj if obj.kind_of?(cls)
    return nil unless obj.respond_to?(meth)
    ret = obj.__send__(meth)
    raise TypeError, "Coercion error: obj.#{meth} did NOT return a #{cls} (was #{ret.class})" unless ret.nil? || ret.kind_of?(cls)
    ret
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

  # Used internally to propagate #lambda?
  def self.track_lambda(from, to, default = false)
    is_lambda = from.instance_variable_get :@is_lambda
    is_lambda = default if is_lambda.nil?
    to.instance_variable_set :@is_lambda, is_lambda
    to
  end

  # Used internally to combine {IO|File} options hash into mode (String or Integer)
  def self.combine_mode_and_option(mode = nil, options = Backports::Undefined)
    # Can't backport autoclose, {internal|external|}encoding
    mode, options = nil, mode if mode.is_a?(Hash) and options == Backports::Undefined
    options = {} if options == Backports::Undefined
    if mode && options[:mode]
      raise ArgumentError, "mode specified twice"
    end
    mode ||= options[:mode] || "r"
    if options[:textmode] || options[:binmode]
      text = options[:textmode] || (mode.is_a?(String) && mode =~ /t/)
      bin  = options[:binmode]  || (mode.is_a?(String) ? mode =~ /b/ : mode & File::Constants::BINARY != 0)
      if text && bin
        raise ArgumentError, "both textmode and binmode specified"
      end
      case
        when !options[:binmode]
        when mode.is_a?(String)
          mode.insert(1, "b")
        else
          mode |= File::Constants::BINARY
      end
    end
    mode
  end

  # Used internally to combine {IO|File} options hash into mode (String or Integer) and perm
  def self.combine_mode_perm_and_option(mode = nil, perm = Backports::Undefined, options = Backports::Undefined)
    mode, options = nil, mode if mode.is_a?(Hash) and perm == Backports::Undefined
    perm, options = nil, perm if perm.is_a?(Hash) and options == Backports::Undefined
    perm = nil if perm == Backports::Undefined
    options = {} if options == Backports::Undefined
    if perm && options[:perm]
      raise ArgumentError, "perm specified twice"
    end
    [combine_mode_and_option(mode, options), perm || options[:perm]]
  end

  def self.write(binary, filename, string, offset, options)
    offset, options = nil, offset if Hash === offset and options == Backports::Undefined
    options = {} if options == Backports::Undefined
    options = {:mode => offset.nil? ? "w" : "r+"}.merge(options)
    args = options[:open_args] || [options]
    File.open(filename, *args) do |f|
      f.binmode if binary && f.respond_to?(:binmode)
      f.seek(offset) unless offset.nil?
      f.write(string)
    end
  end
end

module Kernel
  def require_with_backports(lib)
    begin
      return false unless require_without_backports(lib)
      paths = Backports::StdLib.extended_lib.fetch(lib, nil)
    rescue LoadError
      return false if Backports::StdLib::LoadedFeatures.new.include?(lib)
      raise unless paths = Backports::StdLib.extended_lib.fetch(lib, nil)
      Backports::StdLib::LoadedFeatures.mark_as_loaded(lib)
    end
    if paths
      paths.each do |path|
        require_without_backports(path)
      end
    end
    true
  end
  Backports.alias_method_chain self, :require, :backports
end
