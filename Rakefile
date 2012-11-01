# encoding: utf-8
require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "packable"
    gem.add_dependency "backports"
    gem.summary = "Extensive packing and unpacking capabilities"
    gem.email = "github@marc-andre.ca"
    gem.homepage = "http://github.com/marcandre/packable"
    gem.description = <<-EOS
      If you need to do read and write binary data, there is of course <Array::pack and String::unpack
      The packable library makes (un)packing nicer, smarter and more powerful.
    EOS
    gem.authors = ["Marc-André Lafortune"]
    gem.rubyforge_project = "packable"
    gem.has_rdoc = true
    gem.rdoc_options << '--title' << 'Packable library' <<
                           '--main' << 'README.rdoc' <<
                           '--line-numbers' << '--inline-source'
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

Rake::TestTask.new do |t|
  t.libs << 'lib'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = false
end

Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'packable'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
