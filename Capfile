require 'recap/recipes/rails'
require "whenever/capistrano"
require 'yaml'

set :application, 'histvest'
set :repository, 'https://github.com/globalitdevelopment/histvest.git'

task :production do
  server '185.35.184.76', :app
end

namespace :deploy do 
  task :clear_cache do 
    as_app 'bundle exec rake tmp:clear'
  end
end
after 'deploy:restart', 'deploy:clear_cache'

namespace :unicorn do
  desc "Zero-downtime restart of Unicorn"
  task :restart, :except => { :no_release => true } do
    as_app "kill -s USR2 `cat tmp/unicorn.pid`"
  end

  desc "Start unicorn"
  task :start, :except => { :no_release => true } do
    as_app "bundle exec unicorn -c config/unicorn.rb -D"
  end

  desc "Stop unicorn"
  task :stop, :except => { :no_release => true } do
    as_app "kill -s QUIT `cat tmp/unicorn.pid`"
  end
end
after 'deploy:restart', 'unicorn:restart'

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
