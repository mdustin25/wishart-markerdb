class GenesController < ApplicationController
  include Unearth::Filters::Filterable
  CONVERT_ORDER_HASH = {"up" => "ASC", "down" => "DESC"}
  CONVERT_HEADER_HASH = {"Gene Name"=>"genes.name","Chromosome Number"=>"genes.position","Position"=>"genes.position", "MarkerDB ID" => "marker_mdbids.mdbid"}
  filter_by_groups :gene_location
  respond_to :html, :js
  before_filter :get_categories, :except => :show
  WillPaginate.per_page = 30
  def index
    @genes = if params[:search].blank? && params[:c]
                Gene.joins(:marker_mdbid).exported.page(params[:page]).order("#{CONVERT_HEADER_HASH[params[:c]]} #{CONVERT_ORDER_HASH[params[:d]]}")
              elsif !params[:search] && !params[:c]
                Gene.search_text(params[:search]).order(:name).page(params[:page])
              else
                Gene.search_text(params[:search]).joins(:marker_mdbid).page(params[:page]).order("#{CONVERT_HEADER_HASH[params[:c]]} #{CONVERT_ORDER_HASH[params[:d]]}")
              end
    @test = apply_relation_filters(@genes)
    respond_to do |format|
      format.js
      format.html
    end
  end

  def show
    # puts "params[:id] => #{params.inspect}"
    query_id = params[:id]
    if query_id.match(/^MDB.*$/)
      @gene = Gene.includes(:references).joins(:marker_mdbid).where("marker_mdbids.mdbid = ?",query_id).first
      @gene_sequence_variants = @gene.sequence_variants.paginate(:page => params[:page], :per_page => 3)
      respond_with @gene
    else
      @gene = Gene.includes(:references).find(query_id)
      @gene_sequence_variants = @gene.sequence_variants.paginate(:page => params[:page], :per_page => 3)
      respond_with @gene
    end
  end

  def get_categories
    @categories = ConditionCategory.order(:name).select(:name)
  end

  def load_metabolite_index_objects
  end

  def download_fasta
    query_id = params[:gene_id]
    sequence = GeneSequence.find_by(:type => "GeneSequence", :sequenceable_type => "Gene", :sequenceable_id => query_id)

    header = sequence.header
    chain  = sequence.chain

    file_name = "#{Rails.root}/tmp/fasta/#{header}.fasta"
    if File.file?(file_name)
      send_file ("#{Rails.root}/tmp/fasta/#{header}.fasta")
    else

      File.open(file_name, 'w') { |file| 
        file.write(">#{sequence.header}\n#{sequence.chain}")
      }
      send_file ("#{Rails.root}/tmp/fasta/#{header}.fasta")
    end
  end
end
