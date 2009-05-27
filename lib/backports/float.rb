class Fixnum
  # Standard in ruby 1.9. See official documentation[http://ruby-doc.org/core-1.9/classes/Fixnum.html]
  alias_method :fdiv, :/ unless method_defined? :fdiv
end