class KaryotypeIndication < ActiveRecord::Base
  include Measurement
  
  belongs_to :karyotype

end

# == Schema Information
#
# Table name: karyotype_indications
#
#  id                    :integer(4)      not null, primary key
#  condition_id          :integer(4)
#  indication_type_id    :integer(4)
#  biomarker_category_id :integer(4)
#  indication_modifier   :string(255)
#  karyotype_id          :integer(4)
#  created_at            :datetime        not null
#  updated_at            :datetime        not null
#

