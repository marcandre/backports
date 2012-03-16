class Hash
  # Standard in Ruby 1.8.8. See official documentation[http://ruby-doc.org/core-1.9/classes/Hash.html]
  class << self
    def try_convert(x)
      Backports.try_convert(x, Hash, :to_hash)
    end unless method_defined? :try_convert
  end

  # Standard in Ruby 1.9. See official documentation[http://ruby-doc.org/core-1.9/classes/Hash.html]
  def default_proc=(proc)
    replace(Hash.new(&Backports.coerce_to(proc, Proc, :to_proc)).merge!(self))
  end unless method_defined? :default_proc=

  # Standard in Ruby 1.9. See official documentation[http://ruby-doc.org/core-1.9/classes/Hash.html]
  def assoc(key)
    val = fetch(key) do
      return find do |k, v|
        [k, v] if k == key
      end
    end
    [key, val]
  end unless method_defined? :assoc


  # Standard in Ruby 1.9. See official documentation[http://ruby-doc.org/core-1.9/classes/Hash.html]
  def rassoc(value)
    k = key(value)
    v = fetch(k){return nil}
    [k, fetch(k)] if k || v == value
  end unless method_defined? :rassoc
end
