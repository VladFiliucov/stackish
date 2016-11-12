# config valid only for current version of Capistrano
lock '3.6.1'

set :application, 'stackish'
set :repo_url, 'git@github.com:VladFiliucov/stackish.git'

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/home/deploy/stackish'
set :deploy_user, 'deploy'
set :rvm_ruby_version, '2.3.0@stackish'

# Default value for :linked_files is []
append :linked_files, 'config/database.yml', 'config/private_pub.yml', '.env'

# Default value for linked_dirs is []
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system'

namespace :deploy do
  desc 'Restarting Sidekiq'
  task :restart_sidekiq do
    on roles(:worker) do
      execute :service, "sidekiq restart"
    end
  end

  after "deploy:published", "restart_sidekiq"

  task :restart do
    on roles(:app) do
      execute :touch, release_path.join("tmp/restart.txt")
    end
  end
  after "deploy:published", "restart"
end
