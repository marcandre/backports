# require this file to load all the backports of Ruby 1.8.7
if RUBY_VERSION < "1.8.7"
  require "backports/tools"
  require "backports/std_lib"
  Backports.require_relative_dir
end
