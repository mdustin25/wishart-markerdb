require 'fileutils'
require 'active_support/core_ext/string'

def app_root
  File.expand_path(File.join(File.dirname(__FILE__), "..", ".."))
end

def load_all_db_settings 
  YAML.load(File.read(File.join(app_root, "config", "database.yml")))
end

def load_db_settings
  load_all_db_settings[Rails.env]
end

def get_backup_file_name(env = Rails.env) 
  git_repo = load_db_backup_repo env
  File.join git_repo.dir.to_s , "database_backup.sql"
end

def load_task_settings
  task_settings_file = File.read(File.join(app_root, "config", "tasks.yml"))
  YAML.load(task_settings_file )["db_dump_config"]
end

def check_for_file(file_name)
  unless File.exists? file_name
    raise "File '#{file_name}' not found"
  end
end

def check_env_name(env_name)
  unless ["development","test","production"].include? env_name 
    raise 'Not an acceptable value for env'
  end
end

def mysql_cmd(mysql_command, config)
  mysql  = "#{mysql_command} "
  mysql << "-u#{config['username']} " if config['username']
  mysql << "-p#{config['password']} " if config['password']
  mysql << "-h#{config['host']} "     if config['host']
  mysql << "-P#{config['port']} "     if config['port']
  mysql << config['database']         if config['database']
  mysql
end

def mysqldump(settings, out_file)
  system( mysql_cmd("mysqldump", settings) + "> #{out_file}" )
end

def mysqlload(settings, in_file)
  check_for_file in_file
  system(mysql_cmd("mysql", settings) + "< #{in_file}")
end

def load_db_backup_repo(env = Rails.env)
  task_settings = load_task_settings 

  # check db backup git repo
  if task_settings["backup_location"].nil?
    raise "Need to set backup_location in config/tasks.yml"
  end
  backup_location = File.join(task_settings["backup_location"],env)

  # open or create the git repo
  if File.directory? backup_location
    Git.open backup_location
  else
    Git.init backup_location
  end
end


#simple database backup rake task using mysqldump
namespace :db do
  namespace :dump do

    desc %{Dump the database to a file, optionally give a message to 
    add to the name of the file like rake 'db:dump:sql["message"]'}
    task :sql, :name do |t, args|

      file_name = args[:name]
      settings =  load_db_settings

      output_file  = "#{settings['database']}_#{Time.now.strftime('%Y%M%d')}"
      output_file += "_#{file_name.downcase.strip.gsub /\s+/, "_"}" unless file_name.nil?
      output_file += ".sql"

      print "Dumping to '#{output_file}'\n"
      mysqldump(settings, output_file)

    end
  end

  namespace :load do
    task :sql do |t,args|
      file = ENV["f"] || ENV["file"]

      if file.nil?
        raise "Need to supply a file with f=filename or file=filename.\n"
      end

      settings =  load_db_settings

      mysqlload settings, file

    end
  end

  desc %{Backup database to local git repo.  Need a message for commit. 
        Call like 'rake db:backup["message"]'}
        task :backup, :message do |t,args|

          # get commit message
          message = args[:message]
          if message.nil?
            raise "WARNING: DATABASE NOT BACKED UP.\n\tNeed to provide a message like: 'rake db:backup[\"message\"]'\n"
          end

          settings = load_db_settings
          git_repo = load_db_backup_repo


          # make a tmp file for the backup
          tmp_file = File.join(app_root,"tmp","tmp_from_backup_#{Rails.env}_#{Time.now.strftime('%Y%M%d')}.sql")
          begin 
            mysqldump(settings, tmp_file)

            # mv the file to the git repo
            backup_file = get_backup_file_name
            FileUtils.move tmp_file, backup_file

            # commit the change
            git_repo.add(backup_file)
            git_repo.commit(message)

          ensure
            # make sure the tmp dump file gets deleted
            if File.exists? tmp_file 
              print "\n\nfile exists\n\n\n"
              File.unlink tmp_file
            end
          end

        end

        namespace :backup do
          desc <<-eos.strip_heredoc 
            Load the most recent database from the local backup repo.
            The options from and to are also available used like this:

              rake db:backup:load from=production to=development

            Any options that are left out will just use the current rails
            environment. Also rebuilds sphinx indexes
          eos
          task :load do
            from_env = ENV["from"] || Rails.env
            to_env = ENV["to"] || Rails.env
            check_env_name from_env 
            check_env_name to_env

            in_file = get_backup_file_name(from_env)
            db_settings = load_all_db_settings[to_env]

            mysqlload db_settings, in_file
          
          end
        end

end
