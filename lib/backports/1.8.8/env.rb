class << ENV
  alias_method :key, :index unless method_defined? :key
end