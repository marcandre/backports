require 'enumerator'

class Object
  # Standard in rails. See official documentation[http://api.rubyonrails.org/classes/Object.html]
  def try(method_id, *args, &block)
    send(method_id, *args, &block) unless self.nil? #todo: check new def
  end unless method_defined? :try

  # Standard in ruby 1.9. See official documentation[http://ruby-doc.org/core-1.9/classes/Object.html]
  def tap
    yield self
    self
  end unless method_defined? :tap

  # Standard in rails. See official documentation[http://api.rubyonrails.org/classes/Object.html]
  def returning(obj)
    yield obj
    obj
  end unless method_defined? :returning
  
  Enumerator = Enumerable::Enumerator unless const_defined? :Enumerator # Standard in ruby 1.9
end