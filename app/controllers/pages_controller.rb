class PagesController < ApplicationController
  
  before_filter :get_stats
  DOWNLOAD_PATH = "public/system/downloads/current"

  def get_stats()
    stat_hash = Hash.new
    # obtain file of where summary stat is stored
    #File.open("#{Rails.root}/public/system/summary_stats/current/summary_stats.tsv",'r').each do |line|
    #  line = line.strip()
    #  line_elem = line.split("\t")
    #  stat_hash[line_elem[0]] = line_elem[1]
    #end
    
    @stat_hash = stat_hash
    @categories = ConditionCategory.order(:name).select(:name)
    @chemical_count = 0
    @condition_count = 0
    @gene_count = 0
    @protein_count = 0
    @karyotype_count =0
    @predictive_count = 0
    @diagnostic_count = 0
    @prognostic_count = 0
    @exposure_count = 0
  end
  
  def main
  end

  def about
  end

  def contact; end

  def markerdb_api
    
  end
  
  def downloads
    @all_proteins_tsv = '%.2f KB' % (File.size("#{DOWNLOAD_PATH}/all_proteins.tsv").to_f / 2**20)
    @all_proteins_xml = '%.2f KB' % (File.size("#{DOWNLOAD_PATH}/all_proteins.xml").to_f / 2**20)
    @all_proteins_date = File.ctime("#{DOWNLOAD_PATH}/all_proteins.tsv").strftime("%Y-%m-%d")
    
    @all_chemicals_tsv = '%.2f KB' % (File.size("#{DOWNLOAD_PATH}/all_chemicals.tsv").to_f / 2**20)
    @all_chemicals_xml = '%.2f KB' % (File.size("#{DOWNLOAD_PATH}/all_chemicals.xml").to_f / 2**20)
    @all_chemicals_date = File.ctime("#{DOWNLOAD_PATH}/all_chemicals.tsv").strftime("%Y-%m-%d")
    
    @all_sequence_variants_tsv  = '%.2f KB' % (File.size("#{DOWNLOAD_PATH}/all_sequence_variants.tsv").to_f / 2**20)
    @all_sequence_variants_xml  = '%.2f KB' % (File.size("#{DOWNLOAD_PATH}/all_sequence_variants.xml").to_f / 2**20)
    @all_sequence_variants_date  = File.ctime("#{DOWNLOAD_PATH}/all_sequence_variants.tsv").strftime("%Y-%m-%d")

    @all_karyotypes_tsv  = '%.2f KB' % (File.size("#{DOWNLOAD_PATH}/all_karyotypes.tsv").to_f / 2**20)
    @all_karyotypes_xml  = '%.2f KB' % (File.size("#{DOWNLOAD_PATH}/all_karyotypes.xml").to_f / 2**20)
    @all_karyotypes_date  = File.ctime("#{DOWNLOAD_PATH}/all_karyotypes.tsv").strftime("%Y-%m-%d")

    # @all_diagnostics  = '%.2f KB' % (File.size("#{DOWNLOAD_PATH}/all_diagnostics.tsv").to_f / 2**20)
    # @all_diagnostics_xml  = '%.2f KB' % (File.size("#{DOWNLOAD_PATH}/all_diagnostics.xml").to_f / 2**20)
    # @all_diagnostics_date  = File.ctime("#{DOWNLOAD_PATH}/all_diagnostics.tsv").strftime("%Y-%m-%d")

    @all_diagnostic_chemicals_tsv  = '%.2f KB' % (File.size("#{DOWNLOAD_PATH}/all_diagnostic_chemicals.tsv").to_f / 2**20)
    @all_diagnostic_chemicals_xml = '%.2f KB' % (File.size("#{DOWNLOAD_PATH}/all_diagnostic_chemicals.xml").to_f / 2**20)
    @all_diagnostic_chemicals_date  = File.ctime("#{DOWNLOAD_PATH}/all_diagnostic_chemicals.tsv").strftime("%Y-%m-%d")

    @all_diagnostic_proteins_tsv  = '%.2f KB' % (File.size("#{DOWNLOAD_PATH}/all_diagnostic_proteins.tsv").to_f / 2**20)
    @all_diagnostic_proteins_xml  = '%.2f KB' % (File.size("#{DOWNLOAD_PATH}/all_diagnostic_proteins.xml").to_f / 2**20)
    @all_diagnostic_proteins_date  = File.ctime("#{DOWNLOAD_PATH}/all_diagnostic_proteins.tsv").strftime("%Y-%m-%d")

    @all_diagnostic_karyotypes_tsv  = '%.2f KB' % (File.size("#{DOWNLOAD_PATH}/all_diagnostic_karyotypes.tsv").to_f / 2**20)
    @all_diagnostic_karyotypes_xml  = '%.2f KB' % (File.size("#{DOWNLOAD_PATH}/all_diagnostic_karyotypes.xml").to_f / 2**20)
    @all_diagnostic_karyotypes_date  = File.ctime("#{DOWNLOAD_PATH}/all_diagnostic_karyotypes.tsv").strftime("%Y-%m-%d")

    @all_predictive_genetics_tsv  = '%.2f KB' % (File.size("#{DOWNLOAD_PATH}/all_predictive_genetics.tsv").to_f / 2**20)
    @all_predictive_genetics_xml  = '%.2f KB' % (File.size("#{DOWNLOAD_PATH}/all_predictive_genetics.xml").to_f / 2**20)
    @all_predictive_genetics_date  = File.ctime("#{DOWNLOAD_PATH}/all_predictive_genetics.tsv").strftime("%Y-%m-%d")

    @all_exposure_chemicals_tsv  = '%.2f KB' % (File.size("#{DOWNLOAD_PATH}/all_exposure_chemicals.tsv").to_f / 2**20)
    @all_exposure_chemicals_xml  = '%.2f KB' % (File.size("#{DOWNLOAD_PATH}/all_exposure_chemicals.xml").to_f / 2**20)
    @all_exposure_chemicals_date  = File.ctime("#{DOWNLOAD_PATH}/all_exposure_chemicals.tsv").strftime("%Y-%m-%d")



  end
  
  def text_query
  end

  def download_all_proteins
    # puts "params.inspect => #{params.inspect}"
    if params[:format] == "tsv"
      send_file "#{DOWNLOAD_PATH}/all_proteins.tsv", :type => "application/text", :filename =>  "all_proteins.tsv" 
    elsif params[:format] == "xml"
      send_file "#{DOWNLOAD_PATH}/all_proteins.xml", :type => "application/text", :filename =>  "all_proteins.xml" 
    end
  end

  def download_all_chemicals
    if params[:format] == "tsv"
      send_file "#{DOWNLOAD_PATH}/all_chemicals.tsv", :type => "application/text", :filename =>  "all_chemicals.tsv"   
    elsif params[:format] == "xml"
      send_file "#{DOWNLOAD_PATH}/all_chemicals.xml", :type => "application/text", :filename =>  "all_chemicals.xml"   
    end
  end

  def download_all_sequence_variants
    if params[:format] == "tsv"
      send_file "#{DOWNLOAD_PATH}/all_sequence_variants.tsv", :type => "application/text", :filename =>  "all_sequence_variants.tsv"   
    elsif params[:format] == "xml"
      send_file "#{DOWNLOAD_PATH}/all_sequence_variants.xml", :type => "application/text", :filename =>  "all_sequence_variants.xml"   
    end
  end

  def download_all_karyotypes
    if params[:format] == "tsv"
      send_file "#{DOWNLOAD_PATH}/all_karyotypes.tsv", :type => "application/text", :filename =>  "all_karyotypes.tsv"
    elsif params[:format] == "xml"
      send_file "#{DOWNLOAD_PATH}/all_karyotypes.xml", :type => "application/text", :filename =>  "all_karyotypes.xml"
    end
    
  end
 
  def download_all_diagnostics
    # send_file "#{DOWNLOAD_PATH}/all_diagnostics.tsv", :type => "application/sdf", :filename =>  "all_diagnostics.tsv"   
    # if params[:format] == "tsv"
    #   send_file "#{DOWNLOAD_PATH}/all_karyotypes.tsv", :type => "application/text", :filename =>  "all_karyotypes.tsv"
    # elsif params[:format] == "xml"
    #   send_file "#{DOWNLOAD_PATH}/all_karyotypes.xml", :type => "application/text", :filename =>  "all_karyotypes.xml"
    # end
  end

  def download_all_diagnostic_chemicals
    if params[:format] == "tsv"
      send_file "#{DOWNLOAD_PATH}/all_diagnostic_chemicals.tsv", :type => "application/text", :filename =>  "all_diagnostic_chemicals.tsv"   
    elsif params[:format] == "xml"
      send_file "#{DOWNLOAD_PATH}/all_diagnostic_chemicals.xml", :type => "application/text", :filename =>  "all_diagnostic_chemicals.xml"   
    end
    
  end

  def download_all_diagnostic_proteins
    if params[:format] == "tsv"
      send_file "#{DOWNLOAD_PATH}/all_diagnostic_proteins.tsv", :type => "application/text", :filename =>  "all_diagnostic_proteins.tsv"   
    elsif params[:format] == "xml"
      send_file "#{DOWNLOAD_PATH}/all_diagnostic_proteins.xml", :type => "application/text", :filename =>  "all_diagnostic_proteins.xml"   
    end
  end

  def download_all_diagnostic_karyotypes
    if params[:format] == "tsv"
      send_file "#{DOWNLOAD_PATH}/all_diagnostic_karyotypes.tsv", :type => "application/text", :filename =>  "all_diagnostic_karyotypes.tsv"
    elsif params[:format] == "xml"
      send_file "#{DOWNLOAD_PATH}/all_diagnostic_karyotypes.xml", :type => "application/text", :filename =>  "all_diagnostic_karyotypes.xml"
    end
      
  end

  def download_all_prognostics
    send_file "#{DOWNLOAD_PATH}/all_prognostics.tsv", :type => "application/sdf", :filename =>  "all_prognostics.tsv"   
  end

  def download_all_predictives
    send_file "#{DOWNLOAD_PATH}/all_predictives.tsv", :type => "application/sdf", :filename =>  "all_predictives.tsv"   
  end

  def download_all_predictive_genetics
    if params[:format] == "tsv"
      send_file "#{DOWNLOAD_PATH}/all_predictive_genetics.tsv", :type => "application/text", :filename =>  "all_predictive_genetics.tsv" 
    elsif params[:format] == "xml"
      send_file "#{DOWNLOAD_PATH}/all_predictive_genetics.xml", :type => "application/text", :filename =>  "all_predictive_genetics.xml" 
    end
        
      
  end

  def download_all_exposures
    send_file 'public/system/downloads/all_exposures.tsv', :type => "application/sdf", :filename =>  "all_exposures.tsv"
  end

  def download_all_exposure_chemicals
    if params[:format] == "tsv"
      send_file "#{DOWNLOAD_PATH}/all_exposure_chemicals.tsv", :type => "application/text", :filename =>  "all_exposure_chemicals.tsv"
    elsif params[:format] == "xml"
      send_file "#{DOWNLOAD_PATH}/all_exposure_chemicals.xml", :type => "application/text", :filename =>  "all_exposure_chemicals.xml"
    end
    
  end
  
end
