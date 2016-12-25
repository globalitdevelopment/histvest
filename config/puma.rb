RAILS_ENV = ENV.fetch('RAILS_ENV') { 'development' }

workers Integer(ENV['WEB_CONCURRENCY'] || 2)

threads 0, 5

preload_app! unless RAILS_ENV == 'development'

environment RAILS_ENV

pidfile "tmp/pids/puma.pid"

bind "unix:///tmp/puma.sock"  unless RAILS_ENV == 'development'

plugin :tmp_restart

on_worker_boot do
  ActiveSupport.on_load(:active_record) do
    ActiveRecord::Base.establish_connection
  end

  # reload .env
  require 'dotenv'
  ENV.update Dotenv::Environment.new "#{ENV['HOME']}/.env" if File.exist? "#{ENV['HOME']}/.env"
end

before_fork do
  ActiveRecord::Base.connection_pool.disconnect!
end