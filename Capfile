require 'recap/recipes/rails'
require "whenever/capistrano"
require 'yaml'

set :application, 'histvest'
set :repository, 'https://github.com/globalitdevelopment/histvest.git'

set :foreman_template_option, -> { "--env #{application_home}/.env --concurrency worker=1" }

task :production do
  server '185.35.184.76', :app
end

namespace :deploy do 
  task :clear_cache do 
    as_app 'bundle exec rake tmp:clear'
    as_app 'bundle exec rake misc:cache'
  end
end
after 'deploy:restart', 'deploy:clear_cache'

namespace :search do
  task :reset do
    as_app 'bundle exec rake search:reset'
  end
  task :index do
    as_app 'bundle exec rake search:index'
  end
end


namespace :puma do
  [:start, :stop, :status, :restart].each do |name|
    task name, :except => { :no_release => true } do
      if name == :start
        as_app "bundle exec puma -C config/puma.rb -d"
      else
        as_app "bundle exec pumactl #{name} -C config/puma.rb"  
      end
    end
  end
end
after 'deploy:restart', 'puma:restart'

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
