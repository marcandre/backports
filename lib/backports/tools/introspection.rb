module Backports
  class << self
    attr_accessor :calls

    def introspect
      trace = caller(1)
      _, path, method_name = *trace.first.match(/lib\/backports\/(.*)\.rb:\d+:in `(\w+)'/)
      calls["#{path}##{method_name}"][trace] += 1
    end

    def after_tests
      use_at_exit = true
      if defined?(Minitest)
        puts "Backports detected Minitest"
        use_at_exit = false
        Minitest.after_run { yield }
      end
      if defined?(Rspec)
        puts "Backports detected Minitest"
        use_at_exit = false
        RSpec.configure do |config|
          config.after(:suite) { yield }
        end
      end
      if use_at_exit
        puts "Backports using at_exit"
        at_exit { yield }
      end
    end

    def report(calls)
      uses = calls.sort.map{|key, hash| "#{key} (#{hash.size} uses)"}

      ["Backports used: #{'none!' if calls.empty?}", *uses].join("\n")
    end

    def dump(fn = "./backports_used#{rand}.yml")
      puts report(calls)
      require 'yaml'
      File.open(fn, 'w') { |f| YAML.dump(calls, f) }
    end

    def publish(fn = './backports_used*')
      auth = ":$GITHUB_API_KEY" if ENV['GITHUB_API_KEY']
      # Caution, on Travis, we're in a detached HEAD situation. Assume next h
      last_branch = `git for-each-ref --count=30 --sort=-committerdate refs/heads/ --format='%(refname:short)'`.split.first
      repo_owner = 'marcandre'
      repo = 'backports_bot'
      branch = last_branch
      commit = "git -c user.name='backports' -c user.email='backports_bot@marc-andre.ca' commit -m"
      system [
        "git add #{fn}",
        "#{commit} 'Add backports used [ci-skip]'",
        "git rm .travis.yml",
        "#{commit} 'Coz Travis doesn't respect ci-skip [ci-skip]",
      ].join(' && ')

      puts "Commit ready to be pushed for branch '#{branch}'"
      out = `git push -q https://#{repo_owner}#{auth}@github.com/#{repo_owner}/#{repo} HEAD:#{branch} &2>&1`
      puts out.gsub(ENV['GITHUB_API_KEY'], '<api key>')
    end
  end
  self.calls = Hash.new{|h, k| h[k] = Hash.new(0) }
  after_tests { dump; publish }

  # Slower version with introspection
  def self.alias_method(mod, new_name, old_name)
    mod.instance_eval(<<-RUBY) if mod.method_defined?(old_name) && !mod.method_defined?(new_name)
      def #{new_name}(*args, &block)
        Backports.calls["#{mod}#{new_name}"] += 1
        #{old_name}(*args, &block)
      end
    RUBY
  end
end
