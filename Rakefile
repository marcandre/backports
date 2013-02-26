begin
  require "bundler/gem_tasks"
rescue LoadError
  warn "bundler not installed"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = false
end
task :default => :test
