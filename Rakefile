# encoding: utf-8
require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rcov/rcovtask'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "packable"
    gem.add_dependency "marcandre-backports"
    gem.summary = "Extensive packing and unpacking capabilities"
    gem.email = "github@marc-andre.ca"
    gem.homepage = "http://github.com/marcandre/packable"
    gem.description = <<-EOS
      If you need to do read and write binary data, there is of course <Array::pack and String::unpack
      The packable library makes (un)packing nicer, smarter and more powerful.
    EOS
    gem.authors = ["Marc-André Lafortune"]
    gem.rubyforge_project = "marcandre"
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

Rcov::RcovTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList['test/**/*_test.rb']
  t.verbose = true
end

task :default => :rcov

# stats
begin
  gem 'rails'
  require 'code_statistics'
  namespace :spec do
    desc "Use Rails's rake:stats task for a gem"
    task :statsetup do
      class CodeStatistics
        def calculate_statistics
          @pairs.inject({}) do |stats, pair|
            if 3 == pair.size
              stats[pair.first] = calculate_directory_statistics(pair[1], pair[2]); stats
            else
              stats[pair.first] = calculate_directory_statistics(pair.last); stats
            end
          end
        end
      end
      ::STATS_DIRECTORIES = [['Libraries',   'lib',  /.(sql|rhtml|erb|rb|yml)$/],
                   ['Tests',     'test', /.(sql|rhtml|erb|rb|yml)$/]]
      ::CodeStatistics::TEST_TYPES << "Tests"
    end
  end
  desc "Report code statistics (KLOCs, etc) from the application"
  task :stats => "spec:statsetup" do
    CodeStatistics.new(*STATS_DIRECTORIES).to_s
  end
rescue Gem::LoadError => le
  task :stats do
    raise RuntimeError, "'rails' gem not found - you must install it in order to use this task.n"
  end
end


begin
  require 'rake/contrib/sshpublisher'
  namespace :rubyforge do
    
    desc "Release gem and RDoc documentation to RubyForge"
    task :release => ["rubyforge:release:gem", "rubyforge:release:docs"]
    
    namespace :release do
      desc "Publish RDoc to RubyForge."
      task :docs => [:rdoc] do
        config = YAML.load(
            File.read(File.expand_path('~/.rubyforge/user-config.yml'))
        )

        host = "#{config['username']}@rubyforge.org"
        remote_dir = "/var/www/gforge-projects/marcandre/"
        local_dir = 'rdoc'

        Rake::SshDirPublisher.new(host, remote_dir, local_dir).upload
      end
    end
  end
rescue LoadError
  puts "Rake SshDirPublisher is unavailable or your rubyforge environment is not configured."
end
