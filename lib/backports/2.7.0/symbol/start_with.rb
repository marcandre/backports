require 'backports/1.8.7/string/start_with' unless String.method_defined? :end_with?

unless Symbol.method_defined?(:start_with?)
  class Symbol
    def start_with?(*suffixes)
      to_s.start_with?(*suffixes)
    end
  end
end
