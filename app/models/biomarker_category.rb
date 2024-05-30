# == Schema Information
# Schema version: 20110614222434
#
# Table name: biomarker_categories
#
#  id          :integer(4)      not null, primary key
#  name        :string(255)
#  description :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class BiomarkerCategory < ActiveRecord::Base
  has_many :indication_types
  has_many :biomarker_category_membership
  validates_uniqueness_of :name, :case_sensitive => false
  ALLOWED_BIOMARKERS = ["Karyotype","Protein","Chemical","Gene"]

  
  

  def self.filter_by_biomarker_types(filters)
    myscope = current_scope || all
    return myscope if filters.blank?
    myscope.where(status: statuses)
  end
  # TODO add method to get measurements through indication
  # type, and biomarkers through measurements
end
