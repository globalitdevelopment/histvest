workers Integer(ENV['WEB_CONCURRENCY'] || 2)

#preload_app!

environment ENV['RAILS_ENV'] || 'development'

pidfile "tmp/unicorn.pid"

bind "unix:/tmp/unicorn.sock"

on_worker_boot do

  defined?(ActiveRecord::Base) and ActiveRecord::Base.connection.disconnect!

  # reload .env
  require 'dotenv'
  ENV.update Dotenv::Environment.new "#{ENV['HOME']}/.env" if File.exist? "#{ENV['HOME']}/.env"
end