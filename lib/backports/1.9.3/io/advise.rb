unless IO.method_defined? :advise
  class IO
    def advise(advice, offset=0, len=0)
      case advice
      when  :normal,
            :sequential,
            :random,
            :willneed,
            :dontneed,
            :noreuse
        return nil
      when Symbol
        raise NotImplementedError, "Unsupported advice #{advice}"
      else
        raise TypeError, "advice must be a Symbol"
      end
    end
  end
end
