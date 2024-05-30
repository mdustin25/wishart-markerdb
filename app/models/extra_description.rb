class ExtraDescription < ActiveRecord::Base
  include Linkable
  belongs_to :describable, 
    :polymorphic => :true
end


# == Schema Information
#
# Table name: extra_descriptions
#
#  id               :integer(4)      not null, primary key
#  description      :text
#  source           :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#  describable_id   :integer(4)
#  describable_type :string(255)
#

