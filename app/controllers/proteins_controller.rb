class ProteinsController < ApplicationController
  CONVERT_ORDER_HASH = {"up" => "ASC", "down" => "DESC"}
  CONVERT_HEADER_HASH = {"Marker Type" => "proteins.panel_single", "Protein Name"=>"proteins.name","MarkerDB ID" => "marker_mdbids.mdbid"}
  respond_to :html
  before_filter :get_categories, :except => :show
  WillPaginate.per_page = 20
  def index
    @proteins = if params[:search].blank? && params[:c]
               Protein.joins(:marker_mdbid).exported.page(params[:page]).order("#{CONVERT_HEADER_HASH[params[:c]]} #{CONVERT_ORDER_HASH[params[:d]]}")
              elsif !params[:search] && !params[:c]
                Protein.search_text(params[:search]).joins(:marker_mdbid).page(params[:page])
              else
                Protein.search_text(params[:search]).joins(:marker_mdbid).page(params[:page]).order("#{CONVERT_HEADER_HASH[params[:c]]} #{CONVERT_ORDER_HASH[params[:d]]}")
              end
    @cond_categories= ConditionCategory.order(:name).all
    respond_to do |format|
      format.js
      format.html
    end
    

  end

  def show
    query_id = params[:id]
    if query_id.match(/^MDB.*$/)
      @protein = Protein.joins(:marker_mdbid).where("marker_mdbids.mdbid = ?",query_id).first
    else
      @protein = Protein.find(query_id)
    end
    
    @prot_sequence_obj = PolypeptideSequence.where("type = \"PolypeptideSequence\" and sequenceable_type = \"Protein\" and sequenceable_id = ?",@protein.id).first

    unless @prot_sequence_obj.nil?
      @prot_sequences = @prot_sequence_obj.chain
      @header = @prot_sequence_obj.header
    end
    @external_links = @protein.external_links.
      joins(:link_type).where.not(link_types: {name: "PDB"})

    respond_with @protein
  end

  def get_categories
    @categories = ConditionCategory.order(:name).select(:name)
  end

  def download_fasta
    query_id = params[:protein_id]
    sequence = PolypeptideSequence.find_by(:type => "PolypeptideSequence", :sequenceable_type => "Protein", :sequenceable_id => query_id)

    header = sequence.header
    chain  = sequence.chain
    uniprot_id = sequence.uniprot_id

    file_name = "#{Rails.root}/tmp/fasta/#{header}.fasta"
    if File.file?(file_name)
      send_file ("#{Rails.root}/tmp/fasta/#{header}.fasta")
    else

      File.open(file_name, 'w') { |file| 
        file.write("> #{header} | #{uniprot_id}\n#{chain}\n")
      }
      send_file ("#{Rails.root}/tmp/fasta/#{header}.fasta")
    end
    

  end
end
























































