unless Regexp.method_defined? :match?
  class Regexp
    def match?(*args)
      # Fiber to avoid setting $~
      f = Fiber.new do
        !match(*args).nil?
      end
      f.resume
    end
  end
end
