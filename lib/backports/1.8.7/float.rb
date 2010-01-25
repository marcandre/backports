class Fixnum
  # Standard in ruby 1.8.7+. See official documentation[http://ruby-doc.org/core-1.9/classes/Fixnum.html]
  Backports.alias_method self, :fdiv, :/
end