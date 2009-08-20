# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{packable}
  s.version = "1.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Marc-Andr\303\251 Lafortune"]
  s.date = %q{2009-04-13}
  s.description = %q{If you need to do read and write binary data, there is of course <Array::pack and String::unpack The packable library makes (un)packing nicer, smarter and more powerful.}
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
    "lib/packable.rb",
    "lib/packable/extensions/array.rb",
    "lib/packable/extensions/float.rb",
    "lib/packable/extensions/integer.rb",
    "lib/packable/extensions/io.rb",
    "lib/packable/extensions/object.rb",
    "lib/packable/extensions/proc.rb",
    "lib/packable/extensions/string.rb",
    "lib/packable/mixin.rb",
    "lib/packable/packers.rb",
    "test/packing_doc_test.rb",
    "test/packing_test.rb",
    "test/test_helper.rb"
  ]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/marcandre/packable}
  s.rdoc_options = ["--charset=UTF-8", "--title", "Packable library", "--main", "README.rdoc", "--line-numbers", "--inline-source"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{packable}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Extensive packing and unpacking capabilities}
  s.test_files = [
    "test/packing_doc_test.rb",
    "test/packing_test.rb",
    "test/test_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<backports>, [">= 0"])
    else
      s.add_dependency(%q<backports>, [">= 0"])
    end
  else
    s.add_dependency(%q<backports>, [">= 0"])
  end
end
