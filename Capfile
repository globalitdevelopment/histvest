require 'recap/recipes/rails'
require "whenever/capistrano"

set :application, 'histvest'
set :repository, 'https://github.com/globalitdevelopment/histvest.git'

task :production do
  server '46.101.237.203', :app
end

task :old do
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
  [:start, :stop, :delete, :status, :restart].each do |name|
    task name, :except => { :no_release => true } do
      as_app "pm2 #{name} procs.yml --only web"
    end
  end

  task :reload do
    as_app "touch tmp/restart.txt"
  end
end
after 'deploy:restart', 'puma:reload'

set :whenever_command, "bundle exec whenever"
set :latest_release, fetch(:deploy_to)

before "deploy:update_code", "whenever:clear_crontab"
after "deploy:tag", "whenever:update_crontab"
after "deploy:rollback", "whenever:update_crontab"
