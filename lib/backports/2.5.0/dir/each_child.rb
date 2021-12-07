class Dir
  Backports::EXCLUDED_CHILDREN = ['.', '..'].freeze unless Backports.const_defined?('EXCLUDED_CHILDREN')
  def self.each_child(*args)
    return to_enum(__method__, *args) unless block_given?
    foreach(*args) { |f| yield f unless Backports::EXCLUDED_CHILDREN.include? f }
  end

  def each_child(&block)
    return to_enum(__method__) unless block_given?

    Dir.each_child(path, &block)
    self
  end
end unless Dir.respond_to? :each_child
