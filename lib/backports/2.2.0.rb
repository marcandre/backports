# require this file to load all the backports up to Ruby 2.2
require 'backports/2.1.0'
Backports.require_relative_dir if RUBY_VERSION < '2.2'
