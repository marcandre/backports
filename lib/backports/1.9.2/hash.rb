class Hash
  def keep_if
    return to_enum(:keep_if) unless block_given?
    delete_if{|key, value| ! yield key, value}
  end unless method_defined? :keep_if

  def select!(&block)
    return to_enum(:select!) unless block_given?
    reject!{|key, value| ! yield key, value}
  end unless method_defined? :select!
end
