unless String.method_defined? :match?
  class String
    def match?(*args)
      # Fiber to avoid setting $~
      Backports.introspect # Special 'introspection' edition; not for production use
      f = Fiber.new do
        !match(*args).nil?
      end
      f.resume
    end
  end
end
