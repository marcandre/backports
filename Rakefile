require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rcov/rcovtask'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name = "packable"
    s.summary = "Extensive packing and unpacking capabilities"
    s.email = "github@marc-andre.ca"
    s.homepage = "http://github.com/mal/packable"
    s.description = <<-EOS
      If you need to do read and write binary data, there is of course <Array::pack and String::unpack
      The packable library makes (un)packing nicer, smarter and more powerful."
    EOS
    s.authors = ["Marc-André Lafortune"]
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
    raise RuntimeError, "‘rails’ gem not found - you must install it in order to use this task.n"
  end
end