# require this file to load all the backports up to Ruby 1.9.1 (including all of 1.8.8 and below)

require File.expand_path(File.dirname(__FILE__) + "/tools")
Backports.require_relative "1.8"
Backports.require_relative_dir "1.9.1"