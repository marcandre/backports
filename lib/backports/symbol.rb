class Symbol
  # Standard in ruby 1.9. See official documentation[http://ruby-doc.org/core-1.9/classes/Symbol.html]
  def to_proc
    Proc.new { |*args| args.shift.__send__(self, *args) }
  end unless :to_proc.respond_to?(:to_proc)
  
  [ [%w(<=> casecmp), {:before => "return nil unless args.first.is_a? Symbol" }],
    [%w(capitalize downcase next succ swapcase upcase), {:after => ".to_s"}],
    [%w(=~ [] empty? length match size), {}]
  ].each { |methods, options| methods.each do |method|
    module_eval <<-end_eval
      def #{method}(*args)
        #{options[:before]}
        to_s.#{method}(*args)#{options[:after]}
      end unless method_defined? :#{method}
    end_eval
  end }

  include Comparable unless ancestors.include? Comparable
end
