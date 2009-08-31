class Proc
  # Standard in ruby 1.8.7+. See official documentation[http://ruby-doc.org/core-1.9/classes/Proc.html]
  alias_method :yield, :call unless method_defined? :yield
end
