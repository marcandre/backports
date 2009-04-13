class Array
  # flatten & flatten!, standard in ruby 1.9. See official documentation[http://ruby-doc.org/core-1.9/classes/Array.html]
  unless ([[]].flatten(1) rescue false)

    # Recursively flatten any contained Arrays into an one-dimensional result.
    # Adapted from rubinius'
    def flatten_with_optional_argument(level=nil)
      return flatten_without_optional_argument unless level || level == (1/0.0)
      dup.flatten!(level) || self
    end

    # Flattens self in place as #flatten. If no changes are
    # made, returns nil, otherwise self.
    # Adapted from rubinius'
    def flatten_with_optional_argument!(level=nil)
      return flatten_without_optional_argument! unless level || level == (1/0.0)
      
      ret, out = nil, []
      ret = recursively_flatten_finite(self, out, level)
      replace(out) if ret
      ret
    end

    alias_method_chain :flatten, :optional_argument
    alias_method_chain :flatten!, :optional_argument

    # Helper to recurse through flattening since the method
    # is not allowed to recurse itself. Detects recursive structures.
    # Adapted from rubinius'; recursion guards are not needed because level is finite
    def recursively_flatten_finite(array, out, level)
      ret = nil
      if level <= 0
        out.concat(array)
      else
        array.each do |o|
          if o.respond_to? :to_ary
            recursively_flatten_finite(o.to_ary, out, level - 1)
            ret = self
          else
            out << o
          end
        end
      end
      ret
    end
    private :recursively_flatten_finite
  end # flatten & flatten!
  
  # index
  unless ([1].index{true} rescue false)
    def index_with_block(*arg)
      return index_without_block(*arg) unless block_given? && arg.empty?
      each_with_index{|o,i| return i if yield o}
      return nil
    end
    alias_method_chain :index, :block
    alias_method :find_index, :index
  end
  
  # rindex
  unless ([1].rindex{true} rescue false)
    def rindex_with_block(*arg)
      return rindex_without_block(*arg) unless block_given? && arg.empty?
      reverse_each.each_with_index{|o,i| return size - 1 - i if yield o}
      return nil
    end
    alias_method_chain :rindex, :block
  end

  unless ([1].reverse_each rescue false)
    def reverse_each_with_optional_block(&block)
      return reverse_each_without_optional_block(&block) if block_given?
      to_enum(:reverse_each)
    end
    alias_method_chain :reverse_each, :optional_block
  end
  
  def cycle(*arg, &block)
    return to_enum(:cycle, *arg) unless block_given?
    nb = arg.empty? ? (1/0.0) : arg.first
    nb.to_i.times{each(&block)}
  end unless method_defined? :cycle
end