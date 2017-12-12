unless (__method__ || true rescue false)
  module Kernel
    def __method__
      Backports.introspect # Special 'introspection' edition; not for production use
      m = caller(1).first[/`(.*)'/,1]
      m.to_sym if m
    end
  end
end
