  class ChemicalsController < ApplicationController
  CONVERT_ORDER_HASH = {"up" => "ASC", "down" => "DESC"}
  CONVERT_HEADER_HASH = {"Marker Type"=>"chemicals.panel_single","Chemical Name"=>"chemicals.name","MarkerDB ID" => "marker_mdbids.mdbid"}
  respond_to :html
  before_filter :get_categories, :except => :show
  WillPaginate.per_page = 30

  def index
     @chemicals= if params[:search].blank? && params[:c]
                    Chemical.exported.joins(:marker_mdbid).page(params[:page]).order("#{CONVERT_HEADER_HASH[params[:c]]} #{CONVERT_ORDER_HASH[params[:d]]}")
                  elsif !params[:search] && !params[:c]
                    Chemical.search_text(params[:search]).order(:name).page(params[:page])
                  else
                    Chemical.search_text(params[:search]).joins(:marker_mdbid).page(params[:page]).order("#{CONVERT_HEADER_HASH[params[:c]]} #{CONVERT_ORDER_HASH[params[:d]]}")
                  end
    respond_to do |format|
      format.js
      format.html
    end
    #@cond_categories= ConditionCategory.order(:name).all
    #respond_with @chemicals 
  end



  def show
    query_id = params[:id]
    if query_id.match(/^MDB.*$/)
      @chemical = Chemical.joins(:marker_mdbid).find_by("marker_mdbids.mdbid" => query_id)
    else
      @chemical = Chemical.find(params[:id])
    end
    
    unless @chemical.alogps_solubility.blank?
      converted_solubility = "%f" % @chemical.alogps_solubility.sub("g/l","").strip()
      @formatted_converted_solubility = "#{converted_solubility.to_f.round(4)} g/l"
    else
      @formatted_converted_solubility = ""
    end
    unless @chemical.mono_mass.blank?
      @chemical_mono_mass = @chemical.mono_mass.to_f.round(4)
    else
      @chemical_mono_mass = ""
    end
    unless @chemical.average_mass.blank?
      @chemical_avg_mass = @chemical.average_mass.to_f.round(2)
    else
      @chemical_avg_mass = ""
    end
    unless @chemical.pka.blank?
      @chemical_pka = @chemical.pka.to_f.round(2)
    else
      @chemical_pka = ""
    end
    unless @chemical.logp.blank?
      @chemical_logp = @chemical.logp.to_f.round(2)
    else
      @chemical_logp = ""
    end
    respond_with @chemical
  end

  def get_categories
    @categories = ConditionCategory.order(:name).select(:name)
  end
end
