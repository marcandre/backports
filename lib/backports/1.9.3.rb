# require this file to load all the backports up to Ruby 1.9.3
require 'backports/1.9.2'

if RUBY_VERSION < '1.9.3'
  Backports.warned[:require_std_lib] = true
  require "backports/std_lib"
  Backports.require_relative_dir
end
