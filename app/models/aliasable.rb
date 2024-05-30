# creates a has_many relationship with model_name_aliases
# and creates a method called aliases
module Aliasable 
  extend ActiveSupport::Concern

  included do 
    has_many :aliases, :as => :aliasable,
      :dependent => :destroy
    accepts_nested_attributes_for :aliases, allow_destroy: true
  end

  def names
    aliases.pluck(:name).compact
  end
end


