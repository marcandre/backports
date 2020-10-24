if RUBY_VERSION < '3'
  require './lib/backports/3.0.0/ractor.rb'
  require './lib/backports/2.3.0/string/uminus.rb'

  PATH = './test/test_ractor.rb'
  require './test/mri_runner_patched.rb'

  nil.freeze
  true.freeze
  false.freeze

  exec_test [PATH]
end

