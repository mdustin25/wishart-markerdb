# == Schema Information
# Schema version: 20110610221144
#
# Table name: link_types
#
#  id         :integer(4)      not null, primary key
#  prefix     :string(255)
#  suffix     :string(255)
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class LinkType < ActiveRecord::Base
  validates_presence_of :prefix, :name

  # combine the prefix and suffix to make url
  # TODO join with helper to make more robust
  def url(key)
    "#{prefix}#{key||""}#{suffix}"
  end
  def link; url; end
  def path; url; end

end
