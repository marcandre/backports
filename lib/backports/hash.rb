class Hash
  # New Ruby 1.8.7+ constructor -- not documented, see redmine # 1385
  # <tt>Hash[[[:foo, :bar],[:hello, "world"]]] ==> {:foo => :bar, :hello => "world"}</tt>
  class << self
    alias_method :original_constructor, :[]
    def [](*args)
      return original_constructor(*args) unless args.length == 1 && args.first.is_a?(Array)
      returning({}) do |h|
        args.first.each do |arr|
          next unless arr.respond_to? :to_ary
          arr = arr.to_ary
          next unless (1..2).include? arr.size
          h[arr.at(0)] = arr.at(1)
        end
      end
    end unless (Hash[[[:test, :test]]] rescue false)

    # Standard in Ruby 1.9. See official documentation[http://ruby-doc.org/core-1.9/classes/Hash.html]
    def try_convert(x)
      return nil unless x.respond_to? :to_hash
      x.to_hash
    end unless method_defined? :to_hash
  end

  make_block_optional :delete_if, :each, :each_key, :each_pair, :each_value, :reject, :reject!, :select, :test_on => {:hello => "world!"}

  # Standard in Ruby 1.9. See official documentation[http://ruby-doc.org/core-1.9/classes/Hash.html]
  def default_proc=(proc)
    replace(Hash.new(&Type.coerce_to(proc, Proc, :to_proc)).merge!(self))
  end unless method_defined? :default_proc=

  # Standard in Ruby 1.8.7+. See official documentation[http://ruby-doc.org/core-1.9/classes/Hash.html]
  alias_method :key, :index unless method_defined? :key

  # Standard in rails. See official documentation[http://api.rubyonrails.org/classes/ActiveSupport/CoreExtensions/Hash/Keys.html]
  def reverse_merge(other_hash)
    other_hash.merge(self)
  end

  # Standard in rails. See official documentation[http://api.rubyonrails.org/classes/ActiveSupport/CoreExtensions/Hash/Keys.html]
  def reverse_merge!(other_hash)
    replace(reverse_merge(other_hash))
  end

  # Standard in rails. See official documentation[http://api.rubyonrails.org/classes/ActiveSupport/CoreExtensions/Hash/Keys.html]
  def symbolize_keys
    Hash[map{|key,value| [(key.to_sym rescue key) || key, value] }]
  end unless method_defined? :symbolize_keys

  # Standard in rails. See official documentation[http://api.rubyonrails.org/classes/ActiveSupport/CoreExtensions/Hash/Keys.html]
  def symbolize_keys!
    self.replace(self.symbolize_keys)
  end unless method_defined? :symbolize_keys!

  # Standard in rails. See official documentation[http://api.rubyonrails.org/classes/ActiveSupport/CoreExtensions/Hash/Keys.html]
  def stringify_keys
    Hash[map{|key,value| [key.to_s, value] }]
  end unless method_defined? :stringify_keys

  # Standard in rails. See official documentation[http://api.rubyonrails.org/classes/ActiveSupport/CoreExtensions/Hash/Keys.html]
  def stringify_keys!
    self.replace(self.stringify_keys)
  end unless method_defined? :stringify_keys!
end