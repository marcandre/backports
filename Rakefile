begin
  require "bundler/gem_tasks"
rescue LoadError
  # bundler not installed
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = false
end

class SpecRunner
  STATS = [:files, :examples, :expectations, :failures, :errors]
  attr_reader :stats, :not_found

  def initialize
    @counts = [0] * 5
    @not_found = []
  end

  def run(cmd, path)
    result = `#{cmd}`
    match = result.match(/(\d+) files?, (\d+) examples?, (\d+) expectations?, (\d+) failures?, (\d+) errors?/)
    if match.nil?
      puts "*** mspec returned with unexpected results:"
      puts result
      puts "Command was:", cmd
      exit 1
    end
    _, ex, p, f, e = data = match.captures.map{|x| x.to_i}
    not_found << path if ex == 0
    STATS.each_with_index do |_, i|
      @counts[i] += data[i]
    end
    if f + e > 0
      puts cmd
      puts result
    else
      print "."
      STDOUT.flush
    end
  end

  def stats
    h = {}
    STATS.zip(@counts).each{|k, v| h[k]=v}
    h
  end

  def report
    puts "*** Overall:", stats.map{|a| a.join(' ')}.join(', ')
    puts "No spec found for #{@not_found.join(', ')}" unless @not_found.empty?
  end

  def success?
    stats[:failures] == 0 && stats[:errors] == 0
  end
end

desc "Run specs, where path can be '*/*' (default), 'class/*' or 'class/method'."
task :spec, :path, :action do |t, args|
  args.with_defaults(:path => '*/*', :action => 'ci')
  specs = SpecRunner.new

  # Avoid unclear error message by checking if at least one spec exists in the old specs
  has_frozen_spec = !Dir.glob('frozen_old_spec/rubyspec/core/#{path}_spec.rb')
  if has_frozen_spec || RUBY_VERSION < '1.9'
    mspec_cmds(args[:path], 'frozen_old_spec', args[:action]) do |cmd, path|
      specs.run(cmd, path)
    end
  end

  unless RUBY_VERSION < '1.9' # Give up entirely on running new specs in 1.8.x, mainly because of {hash: 'syntax'}
    mspec_cmds(args[:path], 'spec', args[:action]) do |cmd, path|
      specs.run(cmd, path)
    end
  end
  specs.report
  fail unless specs.success?
end

task :all_spec do # Necessary because of argument passing bug in 1.8.7
  Rake::Task[:spec].invoke
end

desc "Same as spec, but creating tags for failures"
task :spec_tag, :path do |t, args|
  Rake::Task[:spec].invoke(args[:path], 'tag -G fails')
end

if RUBY_VERSION >= '2.4.0'
  require 'rubocop/rake_task'
  RuboCop::RakeTask.new
  task :default => [:rubocop, :test, :all_spec]
else
  task :default => [:test, :all_spec]
end

DEPENDENCIES = Hash.new([]).merge!(
  '1.8.7/argf/chars'     => 'backports/1.8.7/string/each_char',
  '1.8.7/argf/each_char' => 'backports/1.8.7/string/each_char',
  '1.8.7/array/cycle'    => 'backports/1.8.7/stop_iteration',
  '1.8.7/enumerable/entries' => ['backports/1.8.7/enumerable/each_with_index', 'backports/1.8.7/enumerable/to_a'],
  '1.8.7/enumerator/rewind' => 'backports/1.8.7/enumerator/next',
  '1.8.7/hash/reject' => 'backports/1.8.7/integer/even',
  '1.9.1/hash/rassoc'    => 'backports/1.9.1/hash/key',
  '1.9.1/proc/lambda'    => 'backports/1.9.1/proc/curry',
  '1.9.2/complex/to_r'   => 'complex',
  '1.9.2/array/select'    => 'backports/1.8.7/array/select',
  '1.9.2/hash/select'    => 'backports/1.8.7/hash/select',
  '1.9.2/enumerable/each_entry' => 'backports/1.8.7/enumerable/each_with_index',
  '2.0.0/hash/to_h'      => 'backports/1.9.1/hash/default_proc',
  '2.2.0/float/next_float' => 'backports/2.2.0/float/prev_float',
  '2.2.0/float/prev_float' => 'backports/2.2.0/float/next_float',
  '2.3.0/array/bsearch_index' => ['backports/2.3.0/array/dig', 'backports/2.3.0/hash/dig'],
  '2.3.0/array/dig' => ['backports/2.3.0/hash/dig', 'backports/2.3.0/struct/dig'],
  '2.3.0/hash/dig' => ['backports/2.3.0/array/dig', 'backports/2.3.0/struct/dig'],
  '2.3.0/struct/dig' => ['backports/2.3.0/array/dig', 'backports/2.3.0/hash/dig'],
  '2.4.0/fixnum/dup' => ['backports/2.4.0/bignum/dup'],
  '2.4.0/bignum/dup' => ['backports/2.4.0/fixnum/dup'],
  '2.7.0/enumerable/tally' => ['backports/2.4.0/hash/transform_values', 'backports/2.2.0/kernel/itself'],
)
{
  :each_with_index => %w[enumerable/detect enumerable/find enumerable/find_all enumerable/select enumerable/to_a],
  :first => %w[enumerable/cycle io/bytes io/chars io/each_byte io/each_char io/lines io/each_line]
}.each do |req, libs|
  libs.each{|l| DEPENDENCIES["1.8.7/#{l}"] = "backports/1.8.7/enumerable/#{req}" }
end

IGNORE_IN_VERSIONS = {
  '2.3' => %w[
    2.7.0/comparable/clamp
  ],
}

IGNORE = %w[
  3.0.0/ractor/ractor
  3.1.0/enumerable/compact
  3.1.0/struct/keyword_init
  3.2.0/enumerator/product
]

CLASS_MAP = Hash.new{|k, v| k[v] = v}.merge!(
  'match_data' => 'matchdata',  # don't ask me why RubySpec uses matchdata instead of match_data
  'true_class' => 'true',
  'false_class' => 'false',
  'nil_class' => 'nil'
)

EXTRA_SPECS = {
  'queue/close' => %w[queue/pop queue/push queue/closed],
  'enumerable/chain' => %w[enumerator/chain/*]
}

USE_MSPEC_GEM = RUBY_VERSION < '2.1'

SUBMODULE_DROP_SUPPORT_COMMITS = {
  'spec/mspec' => {
    '2.1' => '55568ea^',
    '2.2' => 'b5b13de^',
    '2.3' => 'ca2bc42^',
    '2.4' => '3e7e991^',
    :current => '92c27b8',
  },
  'spec/rubyspec' => {
    '2.1' => '63676e680^',
    '2.2' => '63676e680^',
    '2.3' => '63676e680^',
    '2.4' => '0fff6dc19^',
    '2.5' => '2c444ac19^',
    '2.6' => '055d83c54^',
    :current => '55e1223',
  },
}

def prep_submodule(submodule)
  commit = SUBMODULE_DROP_SUPPORT_COMMITS[submodule][RUBY_VERSION[0..2]] || SUBMODULE_DROP_SUPPORT_COMMITS[submodule][:current]
  cmd = "git -C #{submodule} checkout #{commit}"
  puts cmd
  system cmd
end

def ignore?(version_path)
  return true if IGNORE.include?(version_path)

  IGNORE_IN_VERSIONS.each do |version, paths|
    return false if RUBY_VERSION[0..2] > version
    return true if paths.include? version_path
  end
  false
end

def mspec_cmds(pattern, spec_folder, action='ci')
  pattern = "lib/backports/*.*.*/#{pattern}.rb"
  prep_submodule('spec/mspec')
  prep_submodule('spec/rubyspec')
  Dir.glob(pattern) do |lib_path|
    _match, version, path = lib_path.match(/backports\/(\d\.\d\.\d)\/(.*)\.rb/).to_a
    next if path =~ /stdlib/
    next if version <= RUBY_VERSION
    version_path = "#{version}/#{path}"
    next if ignore?(version_path)
    deps = [*DEPENDENCIES[version_path]].map{|p| "-r #{p}"}.join(' ')
    klass, method = path.split('/')
    path = [CLASS_MAP[klass], method].join('/')
    spec_paths = [path, *EXTRA_SPECS[path]].map do |p|
      p.gsub! /fixnum|bignum/, 'integer'
      "#{spec_folder}/rubyspec/core/#{p}_spec.rb"
    end
    if !File.exist?(spec_paths.first)
      puts "NOT FOUND: No spec found for #{path}"
      next
    end
    if USE_MSPEC_GEM
      cmd = "mspec #{action}"
    else
      cmd = 'ruby'
      main = "spec/mspec/bin/mspec-#{action}"
    end

    yield %W[ #{cmd}
              -I lib
              -r ./set_version/#{version}
              #{deps}
              -r backports/#{version_path}
              #{main}
               #{spec_paths.join(' ')}
            ].join(' '), path
  end
end
