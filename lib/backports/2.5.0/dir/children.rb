class Dir
  Backports::EXCLUDED_CHILDREN = ['.', '..'].freeze
  def self.children(*args)
    entries(*args) - Backports::EXCLUDED_CHILDREN
  end
end unless Dir.respond_to? :children
