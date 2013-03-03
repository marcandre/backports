unless ("abc".upto("def", true){} rescue false)
  require 'backports/tools'

  class String
    def upto_with_exclusive(to, excl=false)
      return upto_without_exclusive(to){|s| yield s} if block_given? && !excl
      enum = Range.new(self, to, excl).to_enum
      return enum unless block_given?
      enum.each{|s| yield s}
      self
    end
    Backports.alias_method_chain self, :upto, :exclusive
  end
end
