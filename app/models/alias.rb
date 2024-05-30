# == Schema Information
# Schema version: 20110711211919
#
# Table name: aliases
#
#  id             :integer(4)      not null, primary key
#  name           :string(255)
#  aliasable_id   :integer(4)
#  aliasable_type :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#

class Alias < ActiveRecord::Base
  belongs_to :aliasable, :polymorphic => true
  validates :name, presence: true,
    uniqueness: {scope: [:aliasable_id,:aliasable_type]}
end
