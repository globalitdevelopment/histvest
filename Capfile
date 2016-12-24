require 'recap/recipes/rails'
require "whenever/capistrano"

set :application, 'histvest'
set :repository, 'https://github.com/globalitdevelopment/histvest.git'

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

set :whenever_command, "bundle exec whenever"
set :latest_release, fetch(:deploy_to)

before "deploy:update_code", "whenever:clear_crontab"
after "deploy:tag", "whenever:update_crontab"
after "deploy:rollback", "whenever:update_crontab"
