class Hash
  # New ruby 1.9 constructor -- not documented?
  # <tt>Hash[[[:foo, :bar],[:hello, "world"]]] ==> {:foo => :bar, :hello => "world"}</tt>
  class << self
    alias_method :original_constructor, :[]
    def [](*arg)
      return original_constructor(*arg) unless arg.length == 1 && arg.first.is_a?(Array)
      returning({}) do |h|
        arg.first.each{|key, value| h[key] = value}
      end
    end unless (Hash[[[:test, :test]]] rescue false)
    
    def try_convert(x)
      return nil unless x.respond_to? :to_hash
      x.to_hash
    end unless method_defined? :to_hash
  end

  # Standard in rails. See official documentation[http://api.rubyonrails.org/classes/ActiveSupport/CoreExtensions/Hash/Keys.html]
  def symbolize_keys
    Hash[map{|key,value| [(key.to_sym rescue key) || key, value] }]
  end unless method_defined? :symbolize_keys

  # Standard in rails. See official documentation[http://api.rubyonrails.org/classes/ActiveSupport/CoreExtensions/Hash/Keys.html]
  def symbolize_keys!
    self.replace(self.symbolize_keys)
  end unless method_defined? :symbolize_keys!
  
  # Standard in ruby 1.9. See official documentation[http://ruby-doc.org/core-1.9/classes/Hash.html]
  alias_method :key, :index unless method_defined? :key
  
  # Standard in rails. See official documentation[http://api.rubyonrails.org/classes/ActiveSupport/CoreExtensions/Hash/Keys.html]
  def reverse_merge(other_hash)
    other_hash.merge(self)
  end
  
  # Standard in rails. See official documentation[http://api.rubyonrails.org/classes/ActiveSupport/CoreExtensions/Hash/Keys.html]
  def reverse_merge!(other_hash)
    replace(reverse_merge(other_hash))
  end
  
  # Standard in ruby 1.9. See official documentation[http://ruby-doc.org/core-1.9/classes/Hash.html]
  def default_proc=(proc)
    replace(Hash.new(&proc).merge!(self))
  end unless method_defined? :default_proc=
end