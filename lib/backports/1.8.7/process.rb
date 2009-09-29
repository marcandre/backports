module Process
  module_function :exec unless class << self; method_defined? :exec; end
end