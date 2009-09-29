require File.expand_path(File.dirname(__FILE__) + "/tools")
Backports.require_relative "1.8.7"
%w(array dir enumerable enumerator hash file integer io kernel method string symbol).each do |lib|
  Backports.require_relative "1.9/#{lib}"
end