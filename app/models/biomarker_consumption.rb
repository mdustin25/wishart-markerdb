class BiomarkerConsumption < ActiveRecord::Base
  has_and_belongs_to_many :chemicals
end
