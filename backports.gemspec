# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{backports}
  s.version = "1.6.8"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Marc-Andr\303\251 Lafortune"]
  s.date = %q{2009-05-01}
  s.description = %q{Essential backports that enable some of the really nice features of ruby 1.8.7, ruby 1.9 and rails from ruby 1.8.6 and earlier.}
  s.email = %q{github@marc-andre.ca}
  s.extra_rdoc_files = [
    "LICENSE",
    "README.rdoc"
  ]
  s.files = [
    "CHANGELOG.rdoc",
    "LICENSE",
    "README.rdoc",
    "Rakefile",
    "VERSION.yml",
    "lib/backports.rb",
    "lib/backports/array.rb",
    "lib/backports/binding.rb",
    "lib/backports/dir.rb",
    "lib/backports/enumerable.rb",
    "lib/backports/enumerator.rb",
    "lib/backports/fixnum.rb",
    "lib/backports/hash.rb",
    "lib/backports/integer.rb",
    "lib/backports/io.rb",
    "lib/backports/kernel.rb",
    "lib/backports/method.rb",
    "lib/backports/module.rb",
    "lib/backports/object.rb",
    "lib/backports/object_space.rb",
    "lib/backports/proc.rb",
    "lib/backports/range.rb",
    "lib/backports/regexp.rb",
    "lib/backports/string.rb",
    "lib/backports/struct.rb",
    "lib/backports/symbol.rb",
    "test/array_test.rb",
    "test/binding_test.rb",
    "test/enumerable_test.rb",
    "test/enumerator_test.rb",
    "test/hash_test.rb",
    "test/kernel_test.rb",
    "test/method_test.rb",
    "test/module_test.rb",
    "test/object_test.rb",
    "test/regexp_test.rb",
    "test/string_test.rb",
    "test/symbol_test.rb",
    "test/test_helper.rb"
  ]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/marcandre/backports}
  s.rdoc_options = ["--charset=UTF-8", "--title", "Backports library", "--main", "README.rdoc", "--line-numbers", "--inline-source"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{backports}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Backports or ruby 1.8.7+ & rails for older ruby.}
  s.test_files = [
    "test/array_test.rb",
    "test/binding_test.rb",
    "test/enumerable_test.rb",
    "test/enumerator_test.rb",
    "test/hash_test.rb",
    "test/kernel_test.rb",
    "test/method_test.rb",
    "test/module_test.rb",
    "test/object_test.rb",
    "test/regexp_test.rb",
    "test/string_test.rb",
    "test/symbol_test.rb",
    "test/test_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
