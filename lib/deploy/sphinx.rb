# after we restart we need to reconfigure sphinx
# and restart the daemon
after "deploy:restart", "thinking_sphinx:rebuild"

# make the thinking sphinx indexes reside in a shared path
namespace :thinking_sphinx do
  desc "symlink to the shared sphinx index"
  task :symlink, :roles => [:app] do
    run "ln -nfs #{shared_path}/sphinx #{current_path}/db"
    run "ln -nfs #{shared_path}/config/sphinx.yml #{current_path}/config"
  end
end
before "thinking_sphinx:symlink", "thinking_sphinx:shared_sphinx_folder"
#before "thinking_sphinx:index", "thinking_sphinx:symlink"
before "thinking_sphinx:configure", "thinking_sphinx:symlink"
#before "thinking_sphinx:configure", "db:symlink"

