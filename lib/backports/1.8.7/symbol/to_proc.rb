unless Symbol.method_defined? :to_proc
  class Symbol
    # Standard in ruby 1.8.7+. See official documentation[http://ruby-doc.org/core-1.9/classes/Symbol.html]
    def to_proc
      Backports.introspect # Special 'introspection' edition; not for production use
      Proc.new { |*args| args.shift.__send__(self, *args) }
    end
  end
end
