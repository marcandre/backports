module Backports
  VERSION = "3.11.2" unless const_defined? :VERSION # the guard is against a redefinition warning that happens on Travis
end
