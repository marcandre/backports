# require this file to load all the backports up to Ruby 3.2
require 'backports/3.1.0'
Backports.require_relative_dir if RUBY_VERSION < '3.2'
