class Symbol
  # Standard in ruby 1.9. See official documentation[http://ruby-doc.org/core-1.9/classes/Symbol.html]
  [ [%w(capitalize downcase next succ swapcase upcase), {:after => ".to_sym"}],
    [%w(=~ [] empty? length match size), {}]
  ].each { |methods, options| methods.each do |method|
    module_eval <<-end_eval
      def #{method}(*args)
        to_s.#{method}(*args)#{options[:after]}
      end unless method_defined? :#{method}
    end_eval
  end }

  # Standard in ruby 1.9. See official documentation[http://ruby-doc.org/core-1.9/classes/Symbol.html]
  def <=>(with)
    return nil unless with.is_a? Symbol
    to_s <=> with.to_s
  end unless method_defined? :"<=>"

  # Standard in ruby 1.9. See official documentation[http://ruby-doc.org/core-1.9/classes/Symbol.html]
  def casecmp(with)
    return nil unless with.is_a? Symbol
    to_s.casecmp(with.to_s)
  end unless method_defined? :casecmp

  # Standard in ruby 1.9. See official documentation[http://ruby-doc.org/core-1.9/classes/Symbol.html]
  unless ancestors.include? Comparable
    alias_method :dont_override_equal_please, :==
    include Comparable
    alias_method :==,  :dont_override_equal_please
  end
  
end