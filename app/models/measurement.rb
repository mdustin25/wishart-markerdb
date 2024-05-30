module Measurement 
  extend ActiveSupport::Concern

  include Linkable
  include CitationOwner

  included do
    belongs_to :condition
    belongs_to :indication_type
    belongs_to :biomarker_category

    belongs_to :quality, polymorphic: true,
      dependent: :destroy

    validates :condition, :indication_type, :biomarker_category, :presence => true
  end

  def biomarker
    self.send self.class.biomarker_getter
  end

  def indication
    self.indication_type.indication
  end 

  module ClassMethods 
    # use this method to set up the model
    # for finding associated biomarker
    # there are two ways to use it:
    # 
    # # with a non polymorphic association
    # belongs_to :gene
    # measurement_of :gene
    # # now biomarker will return gene
    # # and find_all_biomarkers_by_condition will work
    #
    # # or with a polymorphic association included in 
    # # a module
    # belongs_to :solute, :polymorphic => true
    # measurement_of :soluble, :solute
    #
    def measurement_of(*args)
      @biomarker_model  = args.first
      @biomarker_getter = args.last
    end

    def biomarker_getter
      @biomarker_getter
    end

    def biomarker_model
      if @biomarker_model.is_a? Symbol
        @biomarker_model = @biomarker_model.to_s.camelize.constantize 
      end
      @biomarker_model 
    end

    # category scopes
    def for_category(category_name)
      category_name = category_name.to_s
      Concentration.joins(:biomarker_category).
        merge(BiomarkerCategory.where(name:category_name)).where("`concentrations`.exported = true")
    end

    def for_abnormal_conditions
      where("`concentrations`.exported = true and condition_id not in (?)", Condition.not_abnormal_condition_ids)
      # where.not(condition_id: Condition.not_abnormal_condition_ids)
    end

#    def find_all_biomarkers
#      association = self.name.tableize
#      
#      Biomarker.models.select do |model|
#        model.include? @biomarker_model
#      end.map do |klass|
#        klass.joins(association).
#          group("`#{association}`.`id`").to_a
#      end.flatten.uniq
#    end

    
   
  end

  # utility methods

  # returns a list of all the models that include
  # the measurement module
  def self.models 
    ActiveRecord::Base.descendants.select do |klass|
      klass.include? Measurement  # TODO put in module use self.name
    end
  end

end
