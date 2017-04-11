# Standard in Ruby 1.9. See official documentation[http://ruby-doc.org/core-1.9/classes/Prime.html]
class Prime
  # Standard in Ruby 1.9. See official documentation[http://ruby-doc.org/core-1.9/classes/Prime/PseudoPrimeGenerator.html]
  class PseudoPrimeGenerator
    include Enumerable

    def each(&block)
      block_given? ? loop { block.call(succ) } : self.dup
    end unless method_defined? :each
  end

  # Standard in Ruby 1.9. See official documentation[http://ruby-doc.org/core-1.9/classes/Prime/Generator23.html]
  class Generator23 < PseudoPrimeGenerator
    def initialize
      @prime, @step = 1, nil
      super
    end unless method_defined? :initialize

    def succ
      loop do
        if (@step)
          @prime += @step
          @step = 6 - @step
        else
          case @prime
          when 1; @prime = 2
          when 2; @prime = 3
          when 3; @prime = 5; @step = 2
          end
        end
        return @prime
      end
    end unless method_defined? :succ

    alias_method :next,   :succ       unless method_defined? :next
    alias_method :rewind, :initialize unless method_defined? :rewind
  end

  class << self
    # Standard in Ruby 1.9. See official documentation[http://ruby-doc.org/core-1.9/classes/Prime.html]
    def prime?(value, generator = Prime::Generator23.new)
      value = -value if value < 0
      return false   if value < 2
      for num in generator
        q, r = value.divmod num
        return true  if q < num
        return false if r == 0
      end
    end unless method_defined? :prime?
  end
end

class Integer
  # Standard in Ruby 1.9. See official documentation[http://ruby-doc.org/core-1.9/classes/Integer.html]
  def prime?
    Prime.prime?(self)
  end unless method_defined? :prime?
end
