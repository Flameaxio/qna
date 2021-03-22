# config valid for current version and patch releases of Capistrano
lock '~> 3.16.0'

set :application, 'qna'
set :repo_url, 'git@github.com:Flameaxio/qna.git'

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/home/deployer/qna'
set :deploy_user, 'deployer'

# Default value for :linked_files is []
append :linked_files, 'config/database.yml', 'config/master.key'

# Default value for linked_dirs is []
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system', 'public/uploads'

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      #execute :touch, release_path.join('tmp/restart.txt')
      invoke 'unicorn:restart'
    end
  end

  after :publishing, :restart
end

namespace :sidekiq do

  task :restart do
    invoke 'sidekiq:stop'
    invoke 'sidekiq:start'
  end

  before 'deploy:finished', 'sidekiq:restart'

  task :stop do
    on roles(:app) do
      within current_path do
        pid = p capture "ps aux | grep sidekiq | awk '{print $2}' | sed -n 1p"
        execute("kill -9 #{pid}")
      rescue StandardError
        Rails.logger.info('Sidekiq was not running')
      end
    end
  end

  task :start do
    on roles(:app) do
      within current_path do
        execute :bundle, "exec sidekiq -e #{fetch(:stage)} -C config/sidekiq.yml -d"
      end
    end
  end
end
