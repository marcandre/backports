# shareable_constant_value: literal

module Backports
  class Ractor
    class ClosedError < ::StopIteration
    end

    class Error < ::StandardError
    end

    class RemoteError < Error
      attr_reader :ractor

      def initialize(message = nil)
        @ractor = Ractor.current
        super
      end
    end
  end
end
