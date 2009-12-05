require File.expand_path(File.dirname(__FILE__) + "/tools")
%w(array enumerable hash kernel module string).each do |lib|
  Backports.require_relative "rails/#{lib}"
end
