# require this file to load all the backports up to Ruby 2.0.0
if RUBY_VERSION < "2.0.0"
  require 'backports/1.9'
  Backports.require_relative_dir
end
