# == Schema Information
# Schema version: 20110614222434
#
# Table name: biomarker_category_memberships
#
#  id                    :integer(4)      not null, primary key
#  biomarker_id          :integer(4)
#  biomarker_type        :string(255)
#  biomarker_category_id :integer(4)
#

class BiomarkerCategoryMembership < ActiveRecord::Base
  belongs_to :biomarker, :polymorphic => true
  belongs_to :biomarker_category
end
