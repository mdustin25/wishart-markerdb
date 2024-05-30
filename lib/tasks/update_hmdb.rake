namespace :update_hmdb do
  desc "TODO"
  task updatehmdb4: :environment do
    require 'json'

    hmdb = Chemical.first.to_json(only: [:hmdb])
    value = JSON.parse(hmdb)
    if value['hmdb'].length == 9
      Chemical.connection.execute("UPDATE chemicals SET hmdb = REPLACE(hmdb, 'HMDB', 'HMDB00');")
      
      
    elsif value['hmdb'].length == 11
      puts "HMDB ID is already up to HMDB 4.0 format"
      
    else
      puts "Something Went Wrong, #{value}"
      next

    end 
    
  end

  task removeInChI: :environment do
    require 'json'

    Chemical.connection.execute("UPDATE chemicals SET moldb_inchi=REPLACE(moldb_inchi, 'InChI=', '');")
  end    
end
