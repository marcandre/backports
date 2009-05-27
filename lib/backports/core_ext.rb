# These are non-standard extensions

class Module
  # Metaprogramming utility to make block optional.
  # Tests first if block is already optional when given options
  def make_block_optional(*methods)
    options = methods.extract_options!
    methods.each do |selector|
      next unless method_defined? selector
      unless options.empty?
        test_on = options[:test_on] || self.new
        next if (test_on.send(selector, *options.fetch(:arg, [])) rescue false)
      end
      
      arity = instance_method(selector).arity
      last_arg = []
      if arity < 0
        last_arg = ["*rest"]
        arity = -1-arity
      end
      arg_sequence = ((0...arity).map{|i| "arg_#{i}"} + last_arg + ["&block"]).join(", ")

      alias_method_chain(selector, :optional_block) do |aliased_target, punctuation|
        module_eval <<-end_eval
          def #{aliased_target}_with_optional_block#{punctuation}(#{arg_sequence})
            return to_enum(:#{aliased_target}_without_optional_block#{punctuation}, #{arg_sequence}) unless block_given?
            #{aliased_target}_without_optional_block#{punctuation}(#{arg_sequence})
          end
        end_eval
      end
    end
  end
end

module Type
  # From Rubinius
  class << self
    def coerce_to(obj, cls, meth)
      return obj if obj.kind_of?(cls)

      begin
        ret = obj.__send__(meth)
      rescue Exception => e
        raise TypeError, "Coercion error: #{obj.inspect}.#{meth} => #{cls} failed:\n" \
                         "(#{e.message})"
      end
      raise TypeError, "Coercion error: obj.#{meth} did NOT return a #{cls} (was #{ret.class})" unless ret.kind_of? cls
      ret
    end unless method_defined? :coerce_to
  end
  
  def self.coerce_to_comparison(a, b, cmp = (a <=> b))
    raise ArgumentError, "comparison of #{a} with #{b} failed" if cmp.nil?
    return 1 if cmp > 0
    return -1 if cmp < 0
    0
  end unless method_defined? :coerce_to_comparison
end

# From Rubinius
Undefined = Object.new unless Kernel.const_defined? :Undefined