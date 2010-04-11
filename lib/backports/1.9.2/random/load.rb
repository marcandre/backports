require_relative "MT19937"
require_relative "bits_and_bytes"
require_relative "implementation"

class Random
  include Implementation
  class << self
    include Implementation
  end
  srand
end