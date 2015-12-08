source "https://rubygems.org"

ruby '2.1.7'

# Webserver, rails etc
gem 'rails', '~> 4.1.4'

gem 'actionpack-action_caching'

#Database
gem "pg"
gem "database_cleaner"
gem "pg_search"
gem 'paper_trail', '~> 3.0.6'
gem "enumerize"
gem "protected_attributes"

group :development, :test do
  # Testing (rspec)

  gem "rspec-rails"
  gem "selenium-webdriver"
  gem "shoulda-matchers"
  gem "guard-rspec"
  gem "guard-spork"
  gem "spork"
  gem "quiet_assets"
  gem 'simplecov'

  # Annotate model files with fields
  gem "annotate"

  gem "better_errors"
  gem "binding_of_caller"
end

group :test do
  gem "capybara"
  gem "factory_girl_rails"
  gem "fakeweb"
end

# Gems used only for assets and not required
# in production environments by default.
gem "sass-rails", ">= 3.2"
gem "coffee-rails"
gem "uglifier"

#Various frontend
gem "jquery-ui-rails"
gem "rails-backbone"
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
gem "gmaps4rails", "1.5.6"

# To fetch data fra third parties
gem "mechanize"

# Authentication
gem "cancan"

# Copywriting, I18N
gem "localeapp"

#Image uploader
gem "paperclip"
#gem "rmagick"
gem "truncate_html"
# Memcached
gem 'dalli'
gem "jbuilder"

# to manage configurations
gem "figaro"

# For deployment
gem "recap"
gem 'whenever', '~> 0.9.4'
gem 'unicorn'
gem 'dotenv'
gem 'newrelic_rpm'

source 'https://rails-assets.org' do
  gem 'rails-assets-jquery', '1.11.2'
  gem 'rails-assets-jquery-ujs', '1.0.3'
  gem 'rails-assets-bootstrap', '3.2.0'
  gem 'rails-assets-angular', '1.3.9'
  gem 'rails-assets-leaflet', '0.7.3'
  gem 'rails-assets-froala-wysiwyg', '1.2.5'
end
