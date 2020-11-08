# require this file to load all the backports up to Ruby 3.0
require 'backports/2.7.0'
Backports.require_relative_dir if RUBY_VERSION < '3.0'
