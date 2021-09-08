source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.1'

gem 'rails', '~> 6.0.3', '>= 6.0.3.3'

# Basic
gem 'bootsnap', '>= 1.4.2', require: false
gem 'inky-rb', require: 'inky'
gem 'pg', '>= 0.18', '< 2.0'
gem 'premailer-rails'
gem 'puma', '~> 4.1'
gem 'rubocop', require: false
gem 'sass-rails'

# Auth
gem 'devise_token_auth', '~> 1.1.4'

# Cors
gem 'rack-cors', '~> 1.1.1'

# Rendering
gem 'jbuilder', '~> 2.10.1'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'pry', '~> 0.13.1'
  gem 'rspec-rails', '~> 4.0.1'
  gem 'shoulda-matchers', '~> 4.0'
end

group :development do
  gem 'listen', '~> 3.2'
  gem 'rails-erd'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
