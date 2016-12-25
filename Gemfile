source "https://rubygems.org"

gem 'rails', '~> 4.2'
gem 'pg'
gem 'enumerize'
gem 'elasticsearch-model', '~> 0.1.9'
gem 'paper_trail'

gem 'actionpack-action_caching'
gem "protected_attributes"
gem 'responders'

gem "sass-rails"
gem "coffee-rails"
gem "uglifier"

#Various frontend
gem "jquery-ui-rails"
gem "rails-backbone", '0.9.10'
gem "bootstrap-sass", "~> 3.2.0"
gem "fancybox-rails"

#Data grid
gem "datagrid"
gem "fastercsv"
gem "jeweler"
gem "will_paginate"

# Model related
# To use ActiveModel has_secure_password
gem "bcrypt"

# To fetch lat/lon or address of Locations, maps
gem "geocoder"
gem "gmaps4rails", "1.5.7"

# To fetch data fra third parties
gem "localeapp"
gem "mechanize"
gem "cancan"
gem "paperclip"
gem "truncate_html"
gem "jbuilder"
gem 'puma'
# gem 'sidekiq'

group :development, :test do
  gem 'dotenv-rails', :require => 'dotenv/rails-now'
  gem "rspec-rails"
  gem "selenium-webdriver"
  gem "shoulda-matchers"
  gem 'simplecov'
end

group :development do
  gem "better_errors"
  gem "binding_of_caller"
  gem "quiet_assets"
  gem "recap"
end

group :test do
  gem "capybara"
  gem "factory_girl_rails"
  gem "fakeweb"
end

group :production do
  gem 'dotenv'
  gem 'dalli'
  gem 'newrelic_rpm'
  gem 'whenever'
end


source 'https://rails-assets.org' do
  gem 'rails-assets-jquery', '1.11.2'
  gem 'rails-assets-jquery-ujs', '1.0.3'
  gem 'rails-assets-bootstrap', '3.2.0'
  gem 'rails-assets-angular', '1.3.9'
  gem 'rails-assets-leaflet', '0.7.3'
  gem 'rails-assets-froala-wysiwyg', '1.2.5'
end
