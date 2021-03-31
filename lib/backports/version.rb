module Backports
  VERSION = "3.21.0" unless Backports.constants.include? :VERSION # the guard is against a redefinition warning that happens on Travis
end
