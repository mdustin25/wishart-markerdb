require './script/hgmd/hgmd_scraper.rb'

hgmd = HgmdScraper.new
bms = GeneticBm.where("gene is not null").all
progress = ProgressBar.new("fetching", bms.count)
databases = hgmd.databases.keys

nodata = File.open("no_data_genes.txt", "w")

bms.map(&:gene).each do |gene|
  progress.inc
  
  databases.each do |db|
    rows = []
    header = nil
    hgmd.send(db,gene) do |row| 
      header = row.keys if header.nil?
      rows << row.values * "\t"
    end
    
    if rows.length == 0
      nodata.puts gene
      puts gene
      next
    end

    out = File.open("hgmd_data/#{db}/#{gene}.csv","w")
    out.puts header * "\t"
    out.puts rows * "\n"
    out.close

  end

end
progress.finish
nodata.close
