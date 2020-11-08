# require this file to load all the backports up to Ruby 2.7
require 'backports/2.6.0'
Backports.require_relative_dir if RUBY_VERSION < '2.7'
