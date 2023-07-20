# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.0'

gem 'rails', '~> 7.0.4', '>= 7.0.4.1'

# Basic
gem 'bootsnap', '>= 1.4.2', require: false
gem 'inky-rb', require: 'inky'
gem 'pg', '>= 0.18', '< 2.0'
gem 'premailer-rails'
gem 'puma', '~> 4.1'
gem 'rubocop', require: false
gem 'sass-rails'
gem 'sprockets-rails'

# Auth
gem 'devise_token_auth', '~> 1.2', '>= 1.2.1'

# Cors
gem 'rack-cors', '~> 1.1.1'

# Rendering
gem 'active_model_serializers', '~> 0.10.0'
gem 'jbuilder', '~> 2.10.1'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'pry', '~> 0.14.2'
  gem 'rspec-rails', '~> 4.0.1'
  gem 'shoulda-matchers', '~> 4.0'
  gem 'letter_opener_web'
end

group :development do
  gem 'listen', '~> 3.2'
  gem 'rails-erd'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
