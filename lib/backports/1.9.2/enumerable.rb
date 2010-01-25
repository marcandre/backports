module Enumerable
  # Standard in Ruby 1.9.2 See official documentation[http://ruby-doc.org/core-1.9/classes/Enumerable.html]
  def chunk(initial_state = nil, &original_block)
    raise ArgumentError, "no block given" unless block_given?
    ::Enumerator.new do |yielder|
      previous = nil
      accumulate = []
      block = initial_state.nil? ? original_block : Proc.new{|val| original_block.yield(val, initial_state.clone)}
      each do |val|
        key = block.yield(val)
        if key.nil? || (key.is_a?(Symbol) && key.to_s[0,1] == "_")
          yielder.yield [previous, accumulate] unless accumulate.empty?
          accumulate = []
          previous = nil
          case key
          when nil, :_separator
          when :_singleton
            yielder.yield [key, [val]]
          else
            raise RuntimeError, "symbol beginning with an underscore are reserved"
          end
        else
          if previous.nil? || previous == key
            accumulate << val
          else
            yielder.yield [previous, accumulate] unless accumulate.empty?
            accumulate = [val]
          end
          previous = key
        end
      end
      # what to do in case of a break?
      yielder.yield [previous, accumulate] unless accumulate.empty?
    end
  end unless method_defined? :chunk

  # Standard in Ruby 1.9.2 See official documentation[http://ruby-doc.org/core-1.9/classes/Enumerable.html]
  def flat_map(&block)
    return to_enum(:flat_map) unless block_given?
    map(&block).flatten(1)
  end unless method_defined? :flat_map
  Backports.alias_method self, :collect_concat, :flat_map
end