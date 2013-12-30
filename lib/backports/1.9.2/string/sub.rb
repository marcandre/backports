class String
  begin
    "i".sub(/i/, {'i' => 'j'})
  rescue TypeError
    alias_method :old_sub, :sub

    def sub(*args)
      if block_given?
        old_sub(*args) { |*x| yield *x }
      elsif args.length != 2
        old_sub(*args)
      else
        (one, two) = args
        if two.is_a? Hash
          old_sub(one) do |x|
            two[x]
          end
        else
          old_sub(*args)
        end
      end
    end

    alias_method :old_sub!, :sub!

    def sub!(*args)
      if block_given?
        old_sub(*args) { |*x| yield *x }
      elsif args.length != 2
        old_sub(*args)
      else
        (one, two) = args
        if two.is_a? Hash
          old_sub(one) do |x|
            two[x]
          end
        else
          old_sub(*args)
        end
      end
    end
  end
end