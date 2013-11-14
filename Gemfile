source 'https://rubygems.org'
ruby '2.0.0'

gem 'rake', '~> 10.1.0'
gem 'rails', '4.0.1'
gem 'pg'

gem 'bcrypt-ruby', '~> 3.1.2'
gem 'coffee-rails', '~> 4.0.0'
gem 'jbuilder', '~> 1.5.2'
gem 'jquery-rails'
gem 'sass-rails', '~> 4.0.0'
gem 'turbolinks'
gem 'uglifier', '>= 1.0.3'
gem 'unicorn', '~> 4.7.0'

group :production do
  # Heroku log & static asset configuration
  gem 'rails_12factor', '~> 0.0.2'
end

group :development do
  gem 'foreman', require: false
  gem 'letter_opener', '~> 1.1.0'
end

group :development, :test do
  gem 'dotenv-rails', '~> 0.9.0'
  gem 'factory_girl_rails', '~> 4.3.0'
  gem 'pry-rails'
  gem 'rspec-rails', '~> 2.14.0'
end

group :test do
  gem 'email_spec', '~> 1.5.0'
  gem 'database_cleaner', '~> 1.2.0'
  gem 'shoulda-matchers', '~> 2.4.0'
  gem 'simplecov', '~> 0.8.1', require: false
end
