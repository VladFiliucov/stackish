# config valid only for current version of Capistrano
lock '3.6.1'

set :application, 'stackish'
set :repo_url, 'git@github.com:VladFiliucov/stackish.git'

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/home/deploy/stackish'
set :deploy_user, 'deploy'
set :rvm_ruby_version, '2.3.0@stackish'

# Default value for :linked_files is []
append :linked_files, '.env', 'config/database.yml', 'config/private_pub.yml', 'config/private_pub_thin.yml', 'config/secrets.yml'

# Default value for linked_dirs is []
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system', 'public/uploads'

namespace :deploy do
  desc 'Restarting Application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'unicorn:restart'
    end
  end

  after :publishing, :restart

  # desc 'Restarting Sidekiq'
  # task :restart_sidekiq do
  #   on roles(:worker) do
  #     execute :service, "sidekiq restart"
  #   end
  # end
  # # after "deploy:published", "restart_sidekiq"

  # desc 'Start Sidekiq'
  # task :start_sidekiq do
  #   on roles(:app) do
  #     execute :service, "sidekiq -q default -q mailers"
  #   end
  # end
  # after "deploy:published", "start_sidekiq"
end

namespace :private_pub do
  desc 'Start private pub server'
  task :start do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, "exec thin -C config/private_pub_thin.yml start"
        end
      end
    end
  end

  desc 'Stop private pub server'
  task :stop do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, "exec thin -C config/private_pub_thin.yml stop"
        end
      end
    end
  end

  desc 'Restart private pub server'
  task :restart do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, "exec thin -C config/private_pub_thin.yml restart"
        end
      end
    end
  end
end

after 'deploy:restart', 'private_pub:restart'

namespace :elasticsearch do

  desc "Elasticsearch Reindex"
  task :reindex do
    on roles(:app) do
      with rails_env: fetch(:rails_env) do
        execute :bundle, "exec rake searchkick:reindex:all"
      end
    end
  end

  %w[start stop restart].each do |command|
    desc "#{command} elasticsearch"
    task command do
      on roles(:app) do
        run "#{sudo} service elasticsearch #{command}"
      end
    end
  end
end
