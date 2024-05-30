class Karyotype < ActiveRecord::Base

  include Biomarker

  # set_marker_tag  "K"
  # set_marker_type "Cytogenetic"


  # To attach a diagram image to a model you can do:
  #
  #   absolute_path_to_file = '/Users/mike/Downloads/cat_PNG100.png'
  #   k.diagram = open(absolute_path_to_file)
  #   k.save
  #
  has_attached_file :diagram,
    :styles => { :medium => "300x300>", :thumb => "150x150>" },
    :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :diagram, 
    :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
  has_one :marker_mdbid, as: :identifiable
  scope :exported, ->{where("`karyotypes`.exported = true")}

  attr_accessor :frequency, :num_cases

  has_many :involved_genes
  has_many :karyotype_indications do
    def diagnostic
      joins(:indication_type => :biomarker_category).
        where('biomarker_categories.name' => 'Diagnostic')
    end

    def prognostic
      joins(:indication_type => :biomarker_category).
        where('biomarker_categories.name' => 'Prognostic')
    end
  end

  def name
    karyotype
  end
  # for center search bar
  def self.search_text(search)
    # if search term exists return result
    if search
      Karyotype.where('`karyotypes`.exported = true and karyotype LIKE ?', "%#{search}%")
    # else return all results
    else
      Karyotype.exported
    end
  end

  #def filename
    #"karyo/"+self.name+".png"
  #end

end
