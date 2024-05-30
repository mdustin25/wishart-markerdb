class MarkerMdbid < ActiveRecord::Base
	belongs_to :identifiable, polymorphic: true
	validates :mdbid, uniqueness: true
end
