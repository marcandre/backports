source "http://rubygems.org"

gemspec

group :test do
  gem "rake"
  gem 'mspec'
  gem 'activesupport', '~>3.2.0'
  gem 'test-unit'
end

if RUBY_VERSION >= '2.4.0'
  group :development do
    gem 'rubocop', '<1.13.0'
  end
end
