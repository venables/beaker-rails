source 'https://rubygems.org'
ruby '2.1.5'

gem 'rake', '10.4.2'
gem 'rails', '4.2.0'
gem 'pg'

gem 'bcrypt', '3.1.9'
gem 'jbuilder', '2.2.6'
gem 'redis', '3.2.0'
gem 'resque', '1.25.2'
gem 'resque-scheduler', '4.0.0'
gem 'unicorn', '4.8.3'

group :production do
  # Heroku log & static asset configuration
  gem 'rails_12factor', '0.0.3'
end

group :development do
  gem 'foreman', require: false
  gem 'letter_opener', '1.3.0'
  gem 'spring', '1.2.0'
end

group :development, :test do
  gem 'dotenv-rails', '1.0.2'
  gem 'factory_girl_rails', '4.5.0'
  gem 'pry-rails'
  gem 'rspec-rails', '3.1.0'
end

group :test do
  gem 'email_spec', '1.6.0'
  gem 'database_cleaner', '1.4.0'
  gem 'shoulda-matchers', '2.7.0'
  gem 'simplecov', '0.9.1', require: false
end
