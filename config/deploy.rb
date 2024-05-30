# lock '3.11.0' # config valid only for Capistrano 3.11.0

set :application, 'markerdb'
set :repo_url,  "git@bitbucket.org:wishartlab/markerdb.git"
set :scm, :git
set :deploy_to, '/apps/markerdb/project'
set :use_sudo, false
set :linked_files, [
  'config/database.yml', 
  'config/moldb.yml', 
  'config/unearth.yml',
  'config/biodb.yml',
  'config/redis.yml'
]
set :linked_dirs, %w{bin log public/system tmp/fasta}
set :keep_releases, 5

namespace :deploy do
  desc 'Start application'
  task :start do
    on roles(:web) do
      within release_path do
        execute "script/puma.sh", "start"
      end
    end
  end

  desc 'Stop application'
  task :stop do
    on roles(:web) do
      within release_path do
        execute "script/puma.sh", "stop"
      end
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:web) do
      within release_path do
        execute "script/puma.sh", "restart"
      end
    end
  end

  after :publishing, :restart, :cleanup
end

# Flush all redis caches. Not necessary unless large update to database
namespace :redis do
  desc "Flushes all Redis data"
  task :flushall do
    on roles(:web) do
      #execute "redis-cli", "flushall"
    end
  end
end
