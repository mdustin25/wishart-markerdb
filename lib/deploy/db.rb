# TODO make these work properly for any deployment
# ie if db server on a different db

# symlink the database config file to the shared path
namespace :db do
#  desc "Make symlink for database yaml" 
#  task :symlink do
#    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml" 
#  end

  desc "Symlink the database config file"
  task :symlink do 
    # run "ln -nfs #{shared_path}/config/database.yml #{current_path}/config/database.yml" 
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml" 
  end

  # tasks for syncing db with git repo
  desc "Dump and synch backup of production server to git repo"
  task :backup, :roles => :db do
    backup_message = ENV["m"] || "Server backup on #{Time.now.strftime("%a, %d %b %Y, %l:%M%P").squeeze(' ')} ." 
    
    host_opt = "-h'#{remote_db_settings["host"]}'" if remote_db_settings["host"]

    run %{ mysqldump   
      -u'#{remote_db_settings["username"]}'
      -p'#{remote_db_settings["password"]}' 
      #{host_opt || ""}
      '#{remote_db_settings["database"]}' 
      > #{backup_db_file}
    }.gsub( /(\s|\n)+/, " ").strip

    run %{
      cd #{backup_db_in} && 
      umask 002 &&
      git add . && 
      git commit -m "#{backup_message}" &&
      git push origin master &&
      sudo chown -R mike #{synch_db_to}
    }.strip 
  end

  desc "Pull db backups from git"
  task :pull_backup do
    run "cd #{backup_db_in} && git pull"
  end

#  namespace :import do
#    desc "Load backup of production server from git repo" 
#    task :last, :roles => :db do
#      print "run " "mysql -u'#{remote_db_settings["username"]}' -p'#{remote_db_settings["password"]}' -h'#{remote_db_settings["host"]}' '#{remote_db_settings["database"]}' < #{backup_db_file}"
#    end
#  end

end
before "deploy:finalize_update", "db:symlink"
# after "deploy:update_code", "db:symlink" 

