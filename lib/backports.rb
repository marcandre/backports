module Kernel
  # Standard in ruby 1.9.
  def require_relative(relative_feature)
    # Adapted from Pragmatic's "Programming Ruby" (since their version was buggy...)
    file = caller.first.split(/:\d/,2).first
    if /\A\((.*)\)/ =~ file # eval, etc. 
      raise LoadError, "require_relative is called in #{$1}" 
    end 
    require File.expand_path(relative_feature, File.dirname(file))
  end unless method_defined? :require_relative
end

%w(core_ext module kernel array enumerable enumerator string symbol integer numeric fixnum hash proc binding dir io method regexp struct float object_space argf gc env process).each do |lib|
  require_relative "backports/#{lib}"
end