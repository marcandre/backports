# require this file to load all the backports up to Ruby 2.0.0
require 'backports/1.9.3'

if RUBY_VERSION < '2.0'
  Backports.warned[:require_std_lib] = true
  require "backports/std_lib"
  Backports.require_relative_dir
end
