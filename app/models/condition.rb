class Condition < ActiveRecord::Base
    include Aliasable
    include Linkable
    include CitationOwner

    has_and_belongs_to_many :categories, :class_name => "ConditionCategory"
    has_many :extra_descriptions, 
      :as => :describable
    has_many :single_nucleotide_polymorphisms
    serialize :omim_records, Array

    # TODO add associations for all the measurements in automated way 

    # conditions are in a hierarchy like
    # super_condition: Zellweger Syndrome
    # sub_conditions: Zellweger Syndrome, Type I; Zellweger Syndrome, Type II 
    belongs_to :super_condition,
      :class_name => "Condition", :foreign_key => :super_condition_id
    has_many :sub_conditions,
      :class_name => "Condition", :foreign_key => :super_condition_id
    # this is for searches to ensure only exported conditions are searchable
    # both super and subconditions then only applies to those that are already exported.
    # # since super/subconditions are shown
    scope :exported, -> {where(exported: true)}
    scope :super_conditions, -> { where(super_condition_id: nil).exported }
    scope :sub_conditions, -> { where(Condition.arel_table[:super_condition_id].not_eq(nil)).exported }

    # condition don't have any markerdb ids but for full site search to work
    # which require searching of ids for other markers and condition, this relation is needed
    has_one :marker_mdbid, as: :identifiable
    
    


    def self.not_abnormal_condition_ids
      @not_abnormal_condition_ids ||= Condition.
        where(name:["Normal","Not Available"]).
        pluck(:id)
    end

    def self.abnormal
      @not_abnormal_condition_ids ||= Condition.
        where(name:["Normal","Not Available"]).
        pluck(:id)

      where.not(id: not_abnormal_condition_ids)
    end

    def super_condition?
      super_condition_id.blank?
    end

    def sub_condition?
      ! super_condition?
    end

    def other_sub_conditions
      super_condition.sub_conditions.where("id != ?", id)
    end
    # get relevant biomarkers
    def get_relevant_biomarker()
      chem_markers = Chemical.joins(:concentrations,"INNER JOIN biomarker_categories ON `concentrations`.biomarker_category_id = `biomarker_categories`.id").where("`chemicals`.exported = true and `concentrations`.exported = true and `concentrations`.condition_id = ?",self.id).select("chemicals.*,biomarker_categories.name as bmcat_name")
      prot_markers = Protein.joins(:concentrations,"INNER JOIN biomarker_categories ON `concentrations`.biomarker_category_id = `biomarker_categories`.id").where("`proteins`.exported=true and `concentrations`.condition_id = ?",self.id).select("proteins.*,biomarker_categories.name as bmcat_name")
      karyotype_markers = Karyotype.joins(:karyotype_indications,"INNER JOIN biomarker_categories ON `karyotype_indications`.biomarker_category_id = `biomarker_categories`.id").where("`karyotypes`.exported = true and `karyotype_indications`.condition_id = ?",self.id).select("karyotypes.*,biomarker_categories.name as bmcat_name")
      seqvar_markers = SequenceVariant.joins(:sequence_variant_measurements,"INNER JOIN biomarker_categories ON `sequence_variant_measurements`.biomarker_category_id = `biomarker_categories`.id").where("`sequence_variants`.exported = true and `sequence_variant_measurements`.condition_id = ?",self.id).select("sequence_variants.*,biomarker_categories.name as bmcat_name")
      return chem_markers + prot_markers +karyotype_markers + seqvar_markers
    end
    # get panel chemical markers for conditions
    def chem_panel_cond()
      chem_markers = Chemical.joins(:concentrations).where("`chemicals`.name like \"Panel\%\" and `concentrations`.condition_id = ?",self.id).select("`chemicals`.*")
      return chem_markers
    end
    # returns a hash with all the measurements grouped
    # by measurement name like:
    # {:concentrations => [concentration1,concentration2]}
    def all_measurements
      Measurement.models.reduce({}) do |result,klass|
        result[klass.name.tableize.to_sym] = 
          klass.where(:condition_id => self.id, :exported => true)
          #includes(klass.biomarker_getter) TODO make this work with polymorphs
        result
      end
    end
    def chemical_measurements
      Measurement.models.reduce({}) do |result,klass|
        result[klass.name.tableize.to_sym] = 
          klass.where(:condition_id => self.id, :exported => true, :solute_type => "Chemical")
          #includes(klass.biomarker_getter) TODO make this work with polymorphs
        result
      end
    end
    def protein_measurements
      Measurement.models.reduce({}) do |result,klass|
        result[klass.name.tableize.to_sym] = 
          klass.where(:condition_id => self.id, :exported => true, :solute_type => "Protein")
          #includes(klass.biomarker_getter) TODO make this work with polymorphs
        result
      end
    end

    def self.search_text(search)
      if search
        Condition.super_conditions.where('name LIKE ?', "%#{search}%")
      else
        Condition.super_conditions
      end
    end
end

