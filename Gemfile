source 'https://rubygems.org'

# Webserver, rails etc
gem "thin", "~> 1.6.1"
gem 'rails', '4.0.2'
gem 'rb-readline', '0.4.2'
gem "rake", "~> 10.1.1"

#Database
gem "pg", "~> 0.17.1"
gem "database_cleaner", "~> 1.2.0"
gem "pg_search", "~> 0.7.2"
gem "paper_trail", "~> 3.0.0"
gem "enumerize", "~> 0.7.0"
gem "protected_attributes", "~> 1.0.5"

group :development, :test do
  # Testing (rspec)
  
  gem "rspec-rails", "~> 2.14.1"
  gem "selenium-webdriver", "~> 2.39.0"
  gem "shoulda-matchers", "~> 2.4.0"
  gem "guard-rspec", "~> 4.2.3"
  gem "guard-spork", "~> 1.5.1"
  gem "spork", "~> 0.9.2"
  gem "quiet_assets", "~> 1.0.2"

  # Annotate model files with fields
  gem "annotate", "~> 2.6.1"

  gem "better_errors", "~> 1.1.0"
  gem "binding_of_caller", "~> 0.7.2"
end

group :test do
  gem "capybara", "~> 1.1.4"
  gem "factory_girl_rails", "~> 4.3.0"
  gem 'fakeweb', '1.3.0'
end	

# Analyzes code coverage
gem "simplecov", "~> 0.8.2", :require => false, :group => :test

# System dependent gems, for test notification
gem "rb-inotify", "~> 0.9.3"
gem "libnotify", "~> 0.8.2"

# Gems used only for assets and not required
# in production environments by default.
gem "sass-rails", "~> 4.0.1"
gem "coffee-rails", "~> 4.0.1"
gem "uglifier", "~> 2.4.0"


#Various frontend
gem 'jquery-rails', '2.1.4'
gem 'jquery-ui-rails', '4.0.2'
gem 'rails-backbone', '0.9.10'
gem "bootstrap-sass", "~> 2.1.0.0"
gem 'tinymce-rails', '3.5.8.1'
gem 'fancybox-rails'
#gem 'turbolinks'

#Data grid 
gem "datagrid", "~> 1.0.3"
#gem "bson", "~> 1.9.2"
gem "bson_ext", "~> 1.9.2"
gem "fastercsv", "~> 1.5.5"
gem "jeweler", "~> 1.8.8"
gem "will_paginate", "~> 3.0.5"

# Model related
# To use ActiveModel has_secure_password
gem "bcrypt-ruby", "~> 3.1.2"

# To fetch lat/lon or address of Locations, maps
gem 'geocoder', '1.1.8'
gem 'gmaps4rails', '1.5.6'

# To fetch data fra third parties
gem "mechanize", "2.7.2"

# Authentication
gem "cancan" , '1.6.9'

# Copywriting, I18N
gem "localeapp", "~> 0.6.14"

#Image uploader
gem "paperclip", "~> 3.5.2"
#gem 'rmagick'
gem 'truncate_html', '0.9.2'
# Memcached
#gem 'dalli'
gem 'jbuilder'

# to manage configurations
gem "figaro", "~> 0.7.0"

# For deployment
gem "recap"