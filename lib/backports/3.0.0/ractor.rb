if RUBY_VERSION < '2'
  warn 'Ractor not backported to Ruby 1.x'
else
  require_relative '../ractor/ractor' unless defined?(Ractor.current)
end
