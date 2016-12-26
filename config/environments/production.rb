Histvest::Application.configure do
  
  # Code is not reloaded between requests
  config.cache_classes = true

  config.eager_load = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Memcahced store
  config.cache_store = :dalli_store, nil, {expires_in: 1.day, pool_size: 5}

  # session store
  config.session_store = :dalli_store, nil, {expires_in: 1.day, pool_size: 5}

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_files = true

  # Compress JavaScripts and CSS
  config.assets.compress = true

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = false

  # Generate digests for assets URLs
  config.assets.digest = true

  # Specifies the header that your server uses for sending files
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # See everything in the log (default is :info)
  config.log_level = :error

  # Prepend all log lines with the following tags
  config.log_tags = [ :request_id ]

  # Use a different logger for distributed setups
  config.log_formatter = ::Logger::Formatter.new
  config.logger = ActiveSupport::TaggedLogging.new config.logger

  config.action_mailer.default_url_options =  { :host => 'histvest.no' }

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true

  config.action_mailer.smtp_settings = {   
    authentication: :plain,
    domain: 'histvest.no',
    port: 587,
    address: 'smtp.mailgun.org',
    user_name: 'postmaster@histvest.no',
    password: ENV['SMTP_PASS']
  }

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify
end
