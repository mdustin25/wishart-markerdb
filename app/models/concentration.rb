class Concentration < ActiveRecord::Base
  include Measurement
  
  belongs_to :solute, :polymorphic => true
  measurement_of :soluble, :solute
  
  def get_related_norm_conc
  	concentration = Concentration.find_by(:id => self.reference_conc_id)
  	concentration
  	# return Concentration.find(self.reference_conc_id)
  end
#  def to_s
#    "#{level} for #{sex} #{age_range}"
#  end
end


# == Schema Information
#
# Table name: concentrations
#
#  id                    :integer(4)      not null, primary key
#  age_range             :string(255)
#  level                 :string(255)
#  location_name         :string(255)
#  special_constraints   :text
#  sex                   :string(255)
#  biofluid              :string(255)
#  comment               :string(255)
#  range                 :string(255)
#  high                  :float
#  low                   :float
#  mean                  :float
#  units                 :string(255)
#  pvalue                :float
#  created_at            :datetime
#  updated_at            :datetime
#  solute_type           :string(255)
#  solute_id             :integer(4)
#  condition_id          :integer(4)
#  indication_type_id    :integer(4)
#  biomarker_category_id :integer(4)
#  indication_modifier   :string(255)
#  exported   :boolean
#

