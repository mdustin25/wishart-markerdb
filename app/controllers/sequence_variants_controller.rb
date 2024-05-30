class SequenceVariantsController < ApplicationController
  include Unearth::Filters::Filterable
  CONVERT_ORDER_HASH = {"up" => "ASC", "down" => "DESC"}
  CONVERT_HEADER_HASH = {"Marker Type"=>"sequence_variants.marker_type","Chromosome"=>"sequence_variants.chromosome","Position"=>"sequence_variants.position", "MarkerDB ID" => "marker_mdbids.mdbid"}
  filter_by_groups :gene_location, :gene_sequence_type
  respond_to :html, :js
  before_filter :get_categories, :except => :show
  WillPaginate.per_page = 30
  
  def index
    @sequence_variants = if params[:search].blank? && params[:c]
                          SequenceVariant.joins(:marker_mdbid).exported.page(params[:page]).order("#{CONVERT_HEADER_HASH[params[:c]]} #{CONVERT_ORDER_HASH[params[:d]]}")
                        elsif !params[:search] && !params[:c]
                          SequenceVariant.search_text(params[:search]).order(:variation).page(params[:page])
                        else
                         SequenceVariant.search_text(params[:search]).joins(:marker_mdbid).page(params[:page]).order("#{CONVERT_HEADER_HASH[params[:c]]} #{CONVERT_ORDER_HASH[params[:d]]}")
                        end

    @sequence_variants = apply_relation_filters(@sequence_variants)
    @search_param = params[:search]
    respond_to do |format|
      format.js
      format.html
    end
    
  end
  

  # GET /sequence_variants/1
  # GET /sequence_variants/1.json
  def show
    query_id = params[:id]
    if query_id.match(/^MDB.*$/)
      
      @sequence_variants = SequenceVariant.includes(:references).joins(:marker_mdbids).find(params[:id]).where("marker_mdbids.mdbid =?", query_id).first
      respond_with @sequence_variants
    else
      @sequence_variants = SequenceVariant.includes(:references).find(query_id)
      respond_with @sequence_variants
    end
  end

  def get_categories
    @categories = ConditionCategory.order(:name).select(:name)
  end
  def seq_var_params
    params.permit(:c, :d, :search)
  end  
end
