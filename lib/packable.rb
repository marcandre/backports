require "packable/version"
require 'backports'
require_relative 'packable/packers'
require_relative 'packable/mixin'
[Object, Array, String, Integer, Float, IO, Proc].each do |klass|
  require_relative 'packable/extensions/' + klass.name.downcase
  klass.class_eval { include Packable::Extensions.const_get(klass.name) }
end
StringIO.class_eval { include Packable::Extensions::IO } # Since StringIO doesn't inherit from IO
