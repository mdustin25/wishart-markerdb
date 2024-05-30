module Soluble
  extend ActiveSupport::Concern

  included do 
    has_many :concentrations, :as => :solute,
      :extend => BiomarkerCategoryScopes
    accepts_nested_attributes_for :concentrations, allow_destroy: true
  end

  def levels
    concentrations.where("exported = true").order("biofluid, age_range, sex")
  end

  def normal_levels
    levels.where("condition_id = ?", 1) 
  end

  def abnormal_levels
    levels.for_abnormal_conditions
  end
  
  def panel_levels
    
  end
end
