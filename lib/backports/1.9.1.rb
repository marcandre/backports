# require this file to load all the backports up to Ruby 1.9.1 (including all of 1.8.8 and below)
require 'backports/1.8'

if RUBY_VERSION < '1.9.1'
  Backports.warned[:require_std_lib] = true
  require "backports/std_lib"
  Backports.require_relative_dir
end
