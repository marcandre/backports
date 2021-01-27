if RUBY_VERSION < '2'
  warn 'Ractor not backported to Ruby 1.x'
elsif defined?(Ractor.current)
  # all good
else
  # Cloner:
  require_relative '../2.4.0/hash/transform_values'
  require_relative '../2.5.0/hash/transform_keys'
  # Queues & FilteredQueue
  require_relative '../2.3.0/queue/close'

  class Ractor
  end

  module Backports
    Ractor = ::Ractor
  end
  require_relative '../ractor/ractor'
end
