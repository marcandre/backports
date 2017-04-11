# require this file to load all the backports of the Ruby 1.8.x line
if RUBY_VERSION < "1.8"
  require 'backports/1.8.7'
end
