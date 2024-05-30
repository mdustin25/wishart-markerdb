namespace :moldbi do
  desc "Symlink the moldb.yml file"
  task :symlink do 
    run "ln -nfs #{shared_path}/config/moldb.yml #{release_path}/config/moldb.yml" 
  end
end

before "deploy:finalize_update", "moldbi:symlink"
