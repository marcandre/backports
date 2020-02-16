module Backports
  class << self
    attr_accessor :deprecation_warned
    Backports.deprecation_warned = {}

    def deprecate kind, msg
      return if deprecation_warned[kind]
      warn msg
      deprecation_warned[kind] = msg
    end
  end
end
