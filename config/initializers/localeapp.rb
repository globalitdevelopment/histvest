require 'localeapp/rails'

Localeapp.configure do |config|
  config.api_key = ENV['LOCALE_APP_KEY']
  config.sending_environments = []
  config.polling_environments = []
  config.reloading_environments = [:development, :production]
  config.cache_missing_translations = true
end