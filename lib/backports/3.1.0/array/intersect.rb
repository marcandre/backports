unless Array.method_defined? :intersect?
  require 'backports/tools/arguments'

  class Array
    def intersect?(array)
      array = Backports.coerce_to_ary(array)

      if size < array.size
        smaller = self
      else
        smaller, array = array, self
      end
      (array & smaller).size > 0
    end
  end
end
