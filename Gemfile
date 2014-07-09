source "https://rubygems.org"

# Webserver, rails etc
gem "thin"
gem "rails"
gem "rb-readline"
gem "rake"

#Database
gem "pg"
gem "database_cleaner"
gem "pg_search"
gem "paper_trail"
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

# Analyzes code coverage
gem "simplecov", :require => false, :group => :test

# Gems used only for assets and not required
# in production environments by default.
gem "sass-rails"
gem "coffee-rails"
gem "uglifier"


#Various frontend
gem "jquery-rails"
gem "jquery-ui-rails"
gem "rails-backbone"
gem "bootstrap-sass"
gem "tinymce-rails"
gem "fancybox-rails"

#Data grid 
gem "datagrid"
gem "bson_ext"
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
gem "jbuilder"

# to manage configurations
gem "figaro"

# For deployment
gem "recap"