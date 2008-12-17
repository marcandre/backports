module Packable
  module Extensions #:nodoc:
    module Object #:nodoc:
      def self.included(base) #:nodoc:
        base.class_eval do
          class << self
            # include only packers method into Object
            include PackersClassMethod
          end
        end
      end
    end
  end
end