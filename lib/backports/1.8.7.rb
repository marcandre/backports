require File.expand_path(File.dirname(__FILE__) + "/tools")
%w(module kernel array enumerable enumerator string symbol integer numeric fixnum hash proc binding dir io method range regexp struct float object_space argf gc env process).each do |lib|
  Backports.require_relative "1.8.7/#{lib}"
end