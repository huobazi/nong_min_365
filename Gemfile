#source 'https://rubygems.org'
source 'http://ruby.taobao.org'

gem 'rails', '~> 3.2.13'
gem 'pg', '~> 0.15.1'

group :assets do
  gem 'sass-rails',   '~> 3.2.5'
  gem 'coffee-rails', '~> 3.2.2'
  gem 'uglifier', '~> 1.3.0'
end

gem 'bootstrap-sass', '~> 2.3.1.2'
gem "font-awesome-sass-rails", "~> 3.0.2.2"

gem "json", "~> 1.8.0"

# Sidekiq
gem "sidekiq", "~> 2.8.0"
gem 'slim'
gem 'sinatra', '>= 1.3.0', :require => nil

gem "rest-client", "~> 1.6.7"
gem "typhoeus", "~> 0.5.4"
gem "nokogiri", "~> 1.5.9"

gem 'jquery-rails', '~> 2.2.1'
gem "jquery-migrate-rails", "~> 1.1.1"
gem "turbolinks", "~> 1.2.0"
gem 'jquery_mobile_rails', '1.3.0'

gem 'bootstrap_helper', '~> 2.1.2'
gem 'client_side_validations', '~> 3.2.1'
gem 'simple_form', '~> 2.0.4'
gem 'client_side_validations-simple_form', '~> 2.0.1'

# mail service
gem "postmark-rails", "~> 0.5.0"

# Google Analytics performance 
gem "garelic", "0.2.0"

# Newrelic Analytics 
gem "newrelic_rpm", "~> 3.6.4.122"

gem "rails-settings-cached", "~> 0.2.4"

# Pagging
gem 'kaminari', '~> 0.14.1'
gem 'kaminari-bootstrap', '0.1.3'

gem 'cancan', '~> 1.6.8'
gem 'rails-i18n', '~> 0.7.2'

# Tagging
gem 'acts-as-taggable-on', '~> 2.3.3'

# To use ActiveModel has_secure_password
gem 'bcrypt-ruby', '~> 3.0.1'
gem 'ruby-pinyin', '~> 0.1.0'

#gem 'default_value_for', '~> 2.0.1'

# Cells
gem 'cells', '~> 3.8.8'

# For mobile devise
gem 'mobylette', '~> 3.3.2'

# For stack pages
gem "high_voltage", "~> 1.2.1"

# Store files to qiniu
gem "qiniu-rs", "~> 3.4.2"
gem "carrierwave", "~> 0.8.0"
gem "carrierwave-qiniu", "~> 0.0.6"

group :development do
  # Deploy with Mina
  gem "mina", "~> 0.2.1"
  gem 'pry', '~> 0.9.10'
  gem 'annotate', '~> 2.5.0'
  gem 'magic_encoding', '~> 0.0.2'
  gem 'web-app-theme', :git => 'git://github.com/pilu/web-app-theme.git' 
  gem "rails-erd", "~> 1.1.0"
  gem 'meta_request' # for chrome rails_panel
  gem "better_errors", "~> 0.9.0"
  gem 'quiet_assets'
end

group :development, :test do
  gem "rspec-rails", "~> 2.11.4"
end

group :test do
  gem 'factory_girl_rails'
  gem 'shoulda-matchers'
  gem 'capybara'
  gem 'launchy'
  gem 'database_cleaner'
  gem 'simplecov', require: false
end

# Use unicorn as the app server
gem "unicorn", "~> 4.6.2"
gem "god", "~> 0.13.2"
gem 'whenever', '~> 0.8.2', :require => false
