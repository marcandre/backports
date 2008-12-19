# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{packable}
  s.version = "1.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Marc-Andr\303\251 Lafortune"]
  s.date = %q{2008-12-19}
  s.description = %q{If you need to do read and write binary data, there is of course <Array::pack and String::unpack The packable library makes (un)packing nicer, smarter and more powerful.}
  s.email = %q{github@marc-andre.ca}
  s.files = ["CHANGELOG.rdoc", "README.rdoc", "VERSION.yml", "lib/packable", "lib/packable/extensions", "lib/packable/extensions/array.rb", "lib/packable/extensions/float.rb", "lib/packable/extensions/integer.rb", "lib/packable/extensions/io.rb", "lib/packable/extensions/object.rb", "lib/packable/extensions/proc.rb", "lib/packable/extensions/string.rb", "lib/packable/jungle_survival_kit.rb", "lib/packable/mixin.rb", "lib/packable/packers.rb", "lib/packable.rb", "test/packing_doc_test.rb", "test/packing_test.rb", "test/test_helper.rb"]
  s.homepage = %q{http://github.com/marcandre/packable}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.0}
  s.summary = %q{Extensive packing and unpacking capabilities}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
