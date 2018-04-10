# frozen_string_literal: true

# From ActiveSupport
unless Object.method_defined? :try
  class Object
    def try(*a, &b)
      try!(*a, &b) if a.empty? || respond_to?(a.first)
    end
  end

  class NilClass
    def try(*args)
      nil
    end
  end
end
