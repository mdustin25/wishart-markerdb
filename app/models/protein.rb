class Protein < ActiveRecord::Base
  include Biomarker
  include Aliasable
  include Soluble
  
  # set_marker_tag  "P"
  # set_marker_type "Protein"
  
  has_attached_file :structure_image,
    styles: { large: "500x500>", thumb: "150x150>" },
    default_url: "proteins/structure_na/:style.jpg"
  validates_attachment_content_type :structure_image,
    :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]

  # has_many :sequences, dependent: :destroy
  has_one :marker_mdbid, as: :identifiable
  has_many :polypeptide_sequences, :as => :sequenceable, dependent: :destroy
  has_many :gene_sequences, :as => :sequenceable, dependent: :destroy
  has_many :rna_sequences, :as => :sequenceable, dependent: :destroy

  scope :exported, ->{where("exported = true")}
  #default_scope { order(name: :asc) }

  def get_associated_condition_ids()
    condition_id_array = Array.new
    # biomarker cateogry id 
    # 4 = Exposure -> not a condition
    # 5 = Monitor -> No longer used
    all_concentrations = Concentration.for_abnormal_conditions.where("exported = true and solute_type = \"Protein\" and biomarker_category_id not in (4,5) and solute_id = ?",id)
    all_concentrations.each do |each_conc|
      cond_id = each_conc.condition_id
      unless condition_id_array.include?(cond_id)
        condition_id_array << cond_id
      end
    end
    return condition_id_array
  end
  def fetch_structure_image_from_pdb
    return false if pdb_ids.empty?
    pdb_id = pdb_ids.first
    self.structure_image = open(pdb_structure_image_path(pdb_id))
    self.structure_image_pdb_id = pdb_id
    self.save
  end
  def self.search_text(search)
    if search
      Protein.exported.where('name LIKE ?', "%#{search}%")
    else
      Protein.exported
    end
  end
  def pdb_ids
    @pdb_ids ||=
      begin
        pdb_link_type = LinkType.where(name:'pdb').first
        external_links.where(link_type:pdb_link_type).pluck(:key)
      end
  end

  def pdb_structure_image_path(pdb_id)
    "https://www.rcsb.org/pdb/images/#{pdb_id}_bio_r_500.jpg"
  end
  # if protein is not exported, its associated sequences can't be blasted either
  def blastable?
    self.exported  
  end
end

