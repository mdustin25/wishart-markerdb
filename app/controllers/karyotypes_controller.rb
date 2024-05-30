class KaryotypesController < ApplicationController
  include Unearth::Filters::Filterable
  CONVERT_ORDER_HASH = {"up" => "ASC", "down" => "DESC"}
  CONVERT_HEADER_HASH = {"Karyotype Name"=>"karyotypes.karyotype","MarkerDB ID" => "marker_mdbids.mdbid"}
  filter_by_groups :karyotype_chrom
  respond_to :html, :js
  before_filter :get_categories, :except => :show
  WillPaginate.per_page = 30
  def index
    @karyotypes = if params[:search].blank? && params[:c]
                  # no search with order
                    Karyotype.exported.joins(:marker_mdbid).page(params[:page]).order("#{CONVERT_HEADER_HASH[params[:c]]} #{CONVERT_ORDER_HASH[params[:d]]}")
                  # no search and no order
                  elsif !params[:search] && !params[:c]
                    Karyotype.search_text(params[:search]).joins(:marker_mdbid).page(params[:page])
                  # search and order
                  else
                    Karyotype.search_text(params[:search]).joins(:marker_mdbid).page(params[:page]).order("#{CONVERT_HEADER_HASH[params[:c]]} #{CONVERT_ORDER_HASH[params[:d]]}")
                  end
    @karyotypes = apply_relation_filters(@karyotypes)
    respond_to do |format|
      format.js
      format.html
    end
  end

  def show
    query_id = params[:id]
    if query_id.match(/^MDB.*$/)
      @karyotype = Karyotype.joins(:marker_mdbid).where("marker_mdbids.mdbid = ?",query_id).first
      respond_with @karyotype
    else
      @karyotype = Karyotype.find(query_id)
      respond_with @karyotype
    end
  end
  def get_categories
    @categories = ConditionCategory.order(:name).select(:name)
  end
  def download_image
    query_id = params[:id]
    @karyotype = Karyotype.joins(:marker_mdbid).where("marker_mdbids.mdbid = ?",query_id).first
    file_name = @karyotype.diagram.url
    if File.file?(file_name)
      send_file (file_name)
    end
  end

  
end
