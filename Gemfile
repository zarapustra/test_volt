source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = '#{repo_name}/#{repo_name}' unless repo_name.include?('/')
  'https://github.com/#{repo_name}.git'
end

gem 'rails', '~> 5.1.4'
gem 'puma', '~> 3.7'
gem 'bcrypt', '~> 3.1.7'

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'pg'
gem 'jwt'
gem 'multi_json'
gem 'rectify'
gem 'kaminari'
gem 'sidekiq'
gem 'authlogic'


group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'

  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'capybara', '~> 2.13'
  gem 'rspec-rails'
  gem 'selenium-webdriver'
  gem 'database_cleaner', '~>1.6.1'
  gem 'faker', branch: 'master' , git: 'https://github.com/stympy/faker.git'
  gem 'shoulda-matchers', '~> 3.0'
  gem 'factory_girl_rails'
  gem 'rspec-sidekiq'
  gem 'wisper-rspec', require: false # testing rectify::command
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'parallel_tests'
  gem 'pry-rails'
end

=begin
gem 'simple_command'
gem 'trailblazer', '>= 2.0.3'
gem 'trailblazer-rails'
gem 'trailblazer-cells'
gem 'cells-rails'
gem 'cells-slim'
gem 'responders'
gem 'reform'
gem 'reform-rails'
gem 'roar-rails'
# gem 'roar'
gem 'roar-jsonapi'
gem 'authlogic'
gem 'tyrant'
gem 'pundit'
gem 'dry-validation'
gem 'active_model_serializers', '~> 0.10.0'
gem 'jsonapi-resources'
=end