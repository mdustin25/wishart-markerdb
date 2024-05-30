class ConditionsController < ApplicationController

  CONVERT_ORDER_HASH = {"up" => "ASC", "down" => "DESC"}
  CONVERT_HEADER_HASH = {"Condition Names" => "name"}
  respond_to :html, :js
  before_filter :get_categories, :except => :show
  WillPaginate.per_page = 10

  def index
    @conditions = if !params[:search] && params[:c]
                    Condition.super_conditions.page(params[:page]).order("#{CONVERT_HEADER_HASH[params[:c]]} #{CONVERT_ORDER_HASH[params[:d]]}")
                  elsif !params[:search] && !params[:c]
                    Condition.search_text(params[:search]).order(:name).page(params[:page])
                  else
                    Condition.search_text(params[:search]).page(params[:page]).order("#{CONVERT_HEADER_HASH[params[:c]]} #{CONVERT_ORDER_HASH[params[:d]]}")
                  end
    respond_to do |format|
      format.js
      format.html
    end
  end

  def show

    
    @condition = Condition.includes(:categories).find(params[:id])
    @measurements = @condition.all_measurements
    @protein_measurements = @condition.protein_measurements
    @panel_chemicals = @condition.chem_panel_cond()
    @chemical_measurements = @condition.chemical_measurements
    @sequence_variants = SequenceVariantMeasurement.includes(:sequence_variant).where("condition_id = ?",@condition.id).paginate(:page => params[:page], :per_page => 3)
    @karyotype_indications = KaryotypeIndication.includes(:karyotype).where("condition_id = ?",@condition.id)
    @references   = @condition.references.page(params[:ref_page])

  end

  def show_category
    @category = ConditionCategory.
      includes(:conditions).
      find_by_name(params[:category])
    @conditions = @category.conditions.
      super_conditions.
      order(:name).
      page( params[:page] )#.per(40)
  end

  private
  
  def get_categories
     @categories = ConditionCategory.order(:name).select(:name)
  end
  
end

