# require this file to load all the backports up to Ruby 3.3
require 'backports/3.2.0'
Backports.require_relative_dir if RUBY_VERSION < '3.3'
