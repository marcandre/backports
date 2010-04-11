require_relative "MT19937"
require_relative "bits_and_bytes"
require_relative "implementation"

class Random
  include Implementation
  class << self
    include Implementation
  end

  def inspect
    "#<#{self.class.name}:#{object_id}>"
  end

  srand
end