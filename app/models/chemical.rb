class Chemical < ActiveRecord::Base 

  # has_structure resource: 'MarkerDB'

  include Biomarker
  include Aliasable
  include Soluble

  # for now we are using the chemicals from
  # HMDB, if we need to we will make one for MarkerDB
  has_structure :database_name => 'HMDB', 
                :id_field => :hmdb,
                mass_scope: :moldb_filtered_scope

  # has_and_belongs_to_many :consumptions, :class => "BiomarkerConsumption"
  
  
  scope :exported, ->{where("exported = true")}
  has_one :marker_mdbid, as: :identifiable
  def get_associated_condition_ids()
    condition_id_array = Array.new
    panels = self.panel_marker_id
    if !panels.nil?
      panels = panels.split(",")
      panels.each do |panel|
        panel_concentration = Concentration.find_by(solute_id: panel, solute_type: "Chemical")
        if !panel_concentration.nil?
          cond_id = panel_concentration.condition_id
          unless condition_id_array.include?(cond_id) or cond_id == 1
            condition_id_array << cond_id
          end
        end
      end
    end
    # biomarker cateogry id 
    # 4 = Exposure -> not a condition
    # 5 = Monitor -> No longer used
    all_concentrations = Concentration.for_abnormal_conditions.where("exported = true and solute_type = \"Chemical\" and biomarker_category_id not in (5) and solute_id = ?",id)
    all_concentrations.each do |each_conc|
      cond_id = each_conc.condition_id
      unless condition_id_array.include?(cond_id)
        condition_id_array << cond_id
      end
    end
    return condition_id_array
  end

  def self.filter_ascending()
    chemical = Chemical.arel_table
    self.order(:name)

  end

  def self.filter_descending()
    chemical = Chemical.arel_table
    self.order(name: :desc)
  end
  
  def self.search_text(search)
    if search
      Chemical.exported.where('name LIKE ?', "%#{search}%")
    else
      Chemical.exported
    end
  end
  # make the moldb_ methods callable without the
  # moldb_ prefix 
  def method_missing(method,*args)
    if !/^moldb_/.match(method) && self.respond_to?("moldb_#{method}")
      self.send "moldb_#{method}", *args
    else
      super method, *args
    end
  end

  # make respond_to? work for the moldb_ methods without the
  # moldb_ prefix 
  def respond_to?(method,*args)
    super(method,*args) || super("moldb_#{method}",*args)
  end

  def self.moldb_filtered_scope(filters={})
    Chemical.exported
  end

end
