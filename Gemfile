source 'https://rubygems.org'
ruby '2.1.2'

gem 'rake', '~> 10.3.2'
gem 'rails', '4.1.4'
gem 'pg'

gem 'active_model_serializers', '~> 0.8.1'
gem 'angularjs-rails', '~> 1.2.19'
gem 'bcrypt', '~> 3.1.7'
gem 'coffee-rails', '~> 4.0.0'
gem 'jwt', '~> 1.0.0'
gem 'sass-rails', '~> 4.0.3'
gem 'uglifier', '>= 1.3.0'
gem 'underscore-rails', '~> 1.6.0'
gem 'underscore-string-rails', '~> 0.0.2'
gem 'unicorn', '~> 4.8.3'

group :production do
  # Heroku log & static asset configuration
  gem 'rails_12factor', '~> 0.0.2'
end

group :development do
  gem 'foreman', require: false
  gem 'letter_opener', '~> 1.2.0'
  gem 'spring', '~> 1.1.3'
end

group :development, :test do
  gem 'dotenv-rails', '~> 0.11.1'
  gem 'factory_girl_rails', '~> 4.4.1'
  gem 'pry-rails'
  gem 'rspec-rails', '~> 3.0.1'
end

group :test do
  gem 'email_spec', '~> 1.6.0'
  gem 'database_cleaner', '~> 1.3.0'
  gem 'shoulda-matchers', '~> 2.6.1'
  gem 'simplecov', '~> 0.7.1', require: false
end
