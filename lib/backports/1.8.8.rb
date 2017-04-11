# Ruby 1.8.8 has been officially cancelled. As of version 2.2 of backports, <tt>require "backports/1.8.8"</tt>
# does nothing more than require 1.8.7 backports
if RUBY_VERSION < "1.8.8"
  require 'backports/1.8.7'
end
