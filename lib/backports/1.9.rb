require File.expand_path(File.dirname(__FILE__) + "/tools")
Backports.require_relative "1.8.7"
%w(array enumerable enumerator hash integer kernel string symbol).each do |lib|
  Backports.require_relative "1.9/#{lib}"
end