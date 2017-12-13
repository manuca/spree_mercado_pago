# By placing all of Solidus's shared dependencies in this file and then loading
# it for each component's Gemfile, we can be sure that we're only testing just
# the one component of Solidus.
source 'https://rubygems.org'

gem 'coffee-rails'
gem 'sass-rails'
gem 'sqlite3', platforms: %i[ruby mingw mswin x64_mingw]
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw]

group :test do
  gem 'capybara', '~> 2.4'
  gem 'capybara-screenshot', '~> 1.0'
  gem 'database_cleaner', '~> 1.3'
  gem 'email_spec'
  gem 'factory_bot_rails'
  gem 'launchy'
  gem 'mutant-rspec', '~> 0.8'
  gem 'poltergeist', '~> 1.10'
  gem 'rails-controller-testing'
  gem 'rspec-activemodel-mocks', '~> 1.0'
  gem 'rspec-collection_matchers'
  gem 'rspec-its'
  gem 'rspec-rails', '~> 3.4'
  gem 'rspec_junit_formatter'
  gem 'shoulda-callback-matchers', '~> 1.1'
  gem 'shoulda-matchers', '~> 3.1'
  gem 'simplecov'
  gem 'timecop'
  gem 'webmock', '~> 2.1'
  gem 'with_model'
  gem 'ffaker'
end

group :test, :development do
  gem 'pry-byebug'
  gem 'rubocop', require: false
end

gem 'solidus', '~> 2.4'

gemspec
