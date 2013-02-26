module Backports
  VERSION = "3.0.3" unless const_defined? :VERSION # the guard is against a redefinition warning that happens on Travis
end
