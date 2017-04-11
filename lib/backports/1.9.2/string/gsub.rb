class String
  begin
    "i".gsub(/i/, {'i' => 'j'})
  rescue TypeError
    alias_method :old_gsub, :gsub

    def gsub(*args)
      if block_given?
        old_gsub(*args) { |*x| yield *x }
      elsif args.length != 2
        old_gsub(*args)
      else
        (one, two) = args
        if two.is_a? Hash
          old_gsub(one) do |x|
            two[x]
          end
        else
          old_gsub(*args)
        end
      end
    end

    alias_method :old_gsub!, :gsub!

    def gsub!(*args)
      if block_given?
        old_gsub(*args) { |*x| yield *x }
      elsif args.length != 2
        old_gsub(*args)
      else
        (one, two) = args
        if two.is_a? Hash
          old_gsub(one) do |x|
            two[x]
          end
        else
          old_gsub(*args)
        end
      end
    end
  end
end