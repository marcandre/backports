class IO
  # Standard in Ruby 1.9.3 See official documentation[http://ruby-doc.org/core-1.9.3/IO.html#method-i-advise]
  # We're only for a platform not implementing advise, so we return nil.
  def advise(advice, offset=0, len=0)
    case advice
    when  :normal,
          :sequential,
          :random,
          :willneed,
          :dontneed,
          :noreuse
      return nil
    when Symbol
      raise NotImplementedError, "Unsupported advice #{advice}"
    else
      raise TypeError, "advice must be a Symbol"
    end
  end unless method_defined? :advise
end
  
class << IO
  # Standard in Ruby 1.9.3 See official documentation[http://ruby-doc.org/core-1.9.3/IO.html#method-c-write]
  def write(name, string, offset = nil, options = Backports::Undefined)
    Backports.write(false, name, string, offset, options)
  end unless method_defined? :write

  # Standard in Ruby 1.9.3 See official documentation[http://ruby-doc.org/core-1.9.3/IO.html#method-c-binwrite]
  # This method does support an options hash, see http://bugs.ruby-lang.org/issues/5782
  def binwrite(name, string, offset = nil, options = Backports::Undefined)
    Backports.write(true, name, string, offset, options)
  end unless method_defined? :binwrite
end
