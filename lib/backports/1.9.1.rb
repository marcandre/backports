# require this file to load all the backports up to Ruby 1.9.1 (including all of 1.8.8 and below)
if RUBY_VERSION < "1.9.1"
  require 'backports/1.8'
  Backports.require_relative_dir
end
