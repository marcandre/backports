# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'packable/version'

Gem::Specification.new do |gem|
  gem.name          = "packable"
  gem.version       = Packable::VERSION
  gem.authors       = ["Marc-André Lafortune"]
  gem.email         = ["github@marc-andre.ca"]
  gem.description   = %q{If you need to do read and write binary data, there is of course <Array::pack and String::unpack\n      The packable library makes (un)packing nicer, smarter and more powerful.\n}
  gem.summary       = %q{Extensive packing and unpacking capabilities}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.add_runtime_dependency 'backports'
end
