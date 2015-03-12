require 'recap/recipes/rails'
require "whenever/capistrano"
require 'yaml'

set :application, 'histvest'
set :repository, 'https://github.com/globalitdevelopment/histvest.git'

server '185.35.184.76', :app

namespace :deploy do
  task :restart do
    as_app 'touch tmp/restart.txt'
  end
end

namespace :env do
  task :set_figaro do
    figaro_config = YAML.load_file('config/application.yml')
    figaro_env = figaro_config.map do |key,val|
      "#{key}=#{val}"
    end

    env = figaro_env.inject(current_environment) do |env, string|
      env.set_string(string)
      logger.debug "Setting #{string}"
      env
    end
    logger.debug "Env is now: #{env}"
    update_remote_environment(env)
    default
  end
end

set :whenever_command, "bundle exec whenever"
set :latest_release, fetch(:deploy_to)

before "deploy:update_code", "whenever:clear_crontab"
after "deploy:tag", "whenever:update_crontab"
after "deploy:rollback", "whenever:update_crontab"
