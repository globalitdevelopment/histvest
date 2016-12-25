workers Integer(ENV['WEB_CONCURRENCY'] || 2)

threads 0, 5

preload_app!

environment ENV['RAILS_ENV'] || 'development'

pidfile "tmp/pids/puma.pid"

bind "unix:/tmp/puma.sock"

plugin :tmp

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