# require this file to load all the backports up to Ruby 3.1
require 'backports/3.0.0'
Backports.require_relative_dir if RUBY_VERSION < '3.1'
