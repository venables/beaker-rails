source 'https://rubygems.org'
ruby '2.0.0'

gem 'rake', '~> 10.1.0'
gem 'rails', '4.0.0'
gem 'pg'

gem 'bcrypt-ruby', '~> 3.0.1'
gem 'coffee-rails', '~> 4.0.0'
gem 'jbuilder', '~> 1.4.2'
gem 'jquery-rails'
gem 'sass-rails', '~> 4.0.0'
gem 'turbolinks'
gem 'uglifier', '>= 1.0.3'
gem 'unicorn', '~> 4.6.2'

group :production do
  # Heroku log & static asset configuration
  gem 'rails_12factor', '~> 0.0.2'
end

group :development do
  gem 'foreman', require: false
  gem 'letter_opener', '~> 1.1.0'
end

group :development, :test do
  gem 'dotenv-rails', '~> 0.8.0'
  gem 'factory_girl_rails', '~> 4.2.1'
  gem 'pry-rails'
  gem 'rspec-rails', '~> 2.14.0'
end

group :test do
  gem 'email_spec', '~> 1.4.0'
  gem 'database_cleaner', '~> 1.0.1'
  gem 'faker', '~> 1.1.2'
  gem 'shoulda-matchers', '~> 2.2.0'
  gem 'simplecov', '~> 0.7.1', require: false
end
