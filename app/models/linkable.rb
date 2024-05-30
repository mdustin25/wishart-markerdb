# creates a has_many relationship with model_name_links
# and creates a method called links
module Linkable 
  extend ActiveSupport::Concern

  included do
    # polymorphic external links
    has_many :external_links, :as => :linkable,
      :dependent => :destroy
  end

  # add alias for external_links
  def links 
    external_links
  end
end


