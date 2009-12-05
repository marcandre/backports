# require this file to load all the backports of Ruby 1.8.7

require File.expand_path(File.dirname(__FILE__) + "/tools")
Backports.require_relative_dir "1.8.7"
