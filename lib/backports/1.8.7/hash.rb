class Hash
  # New Ruby 1.8.7+ constructor -- not documented, see redmine # 1385
  # <tt>Hash[[[:foo, :bar],[:hello, "world"]]] ==> {:foo => :bar, :hello => "world"}</tt>
  unless (Hash[[[:test, :test]]] rescue false)
    class << self
      alias_method :constructor_without_key_value_pair_form, :[]
      def [](*args)
        return constructor_without_key_value_pair_form(*args) unless args.length == 1 && args.first.is_a?(Array)
        h = {}
        args.first.each do |arr|
          next unless arr.respond_to? :to_ary
          arr = arr.to_ary
          next unless (1..2).include? arr.size
          h[arr.at(0)] = arr.at(1)
        end
        h
      end
    end
  end

  # Ruby 1.8.6 doesn't define a Hash specific hash method
  def hash
    h = 0
    each do |key, value|
      h ^= key.hash ^ value.hash
    end
    h
  end unless {}.hash == {}.hash

  # Ruby 1.8.6 doesn't define a Hash specific eql? method.
  def eql?(other)
    other.is_a?(Hash) &&
      size == other.size &&
      all? do |key, value|
        other.fetch(key){return false}.eql?(value)
      end
  end unless {}.eql?({})

  Backports.make_block_optional self, :delete_if, :each, :each_key, :each_pair, :each_value, :reject, :reject!, :select, :test_on => {:hello => "world!"}

  # Standard in Ruby 1.8.7+. See official documentation[http://ruby-doc.org/core-1.9/classes/Hash.html]
  Backports.alias_method self, :key, :index
end