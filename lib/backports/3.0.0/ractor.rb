if RUBY_VERSION < '2'
  warn 'Ractor not backported to Ruby 1.x'
elsif defined?(Ractor.current)
  # all good
else
  class Ractor
  end

  module Backports
    Ractor = ::Ractor
  end
  require_relative '../ractor/ractor'
end
