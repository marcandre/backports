require 'backports/1.8.7/string/end_with' unless String.method_defined? :end_with?

unless Symbol.method_defined?(:end_with?)
  class Symbol
    def end_with?(*suffixes)
      to_s.end_with?(*suffixes)
    end
  end
end
