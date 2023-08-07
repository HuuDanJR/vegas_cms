source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.3', '>= 6.0.3.4'
# Use sqlite3 as the database for Active Record
gem 'mysql2', '>= 0.4.4'
# Use Puma as the app server
gem 'puma', '~> 4.1'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 4.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

# Get config environment from file
gem 'dotenv-rails', '~> 2.7', '>= 2.7.6'
# Use devise support manage users
gem 'devise', '~> 4.7', '>= 4.7.3'
# Use oAuth2 provider
gem 'doorkeeper', '~> 5.4'
# Implement OpenID Connect
gem 'doorkeeper-openid_connect', '~> 1.7', '>= 1.7.5'
# Use access token with jwt
gem 'doorkeeper-jwt', '~> 0.4.0'
# Use CORS
gem 'rack-cors', '~> 1.1', '>= 1.1.1'
# Sign in with facebook - omniauth facebook
gem 'omniauth-facebook', '~> 6.0'
# Use paging
gem 'will_paginate', '~> 3.3.0'
# Manage file
gem 'carrierwave', '~> 2.1'
# Geocoding
gem 'geocoder', '~> 1.6', '>= 1.6.4'
# Read access spreadsheet types: excel, csv
gem 'roo', '~> 2.8', '>= 2.8.3'
# Use redis cache
gem 'redis', '~> 4.2', '>= 4.2.5'
# Export file excel
gem 'caxlsx', '~> 3.0', '>= 3.0.4'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
