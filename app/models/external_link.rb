# == Schema Information
# Schema version: 20110614222434
#
# Table name: external_links
#
#  id            :integer(4)      not null, primary key
#  linkable_id   :integer(4)
#  linkable_type :string(255)
#  name          :string(255)
#  key           :string(255)
#  url           :string(255)
#  link_type_id  :integer(4)
#


# Polymorphic model used by almost all of the 
# data models.  This model is linked with the
# link type model.  If a link has no name or url
# the the link type's name or url are used 
class ExternalLink < ActiveRecord::Base
  belongs_to :linkable, :polymorphic => true
  belongs_to :link_type

  # needs to have either name + url OR key + link_type
  validates_presence_of :name,         :if => :no_link_type?  
  validates_presence_of :url,          :if => :no_link_type?
  validates_presence_of :key,          :if => :name_or_url_missing?
  validates_presence_of :link_type_id, :if => :name_or_url_missing?

  # return the custom url if it exists
  # otherwise the link_type url
  def name
    self[:name] or (link_type and link_type.name)
  end

  # return the custom url if it exists
  # otherwise the link_type url
  def url
    self[:url] or (link_type and link_type.url(key))
  end
  def path; url; end

  # set the link type with its name
  def link_type_name=(type_name)
    type = LinkType.find_by_name(type_name)
    if type.nil?
      type = LinkType.create(:name => type_name, :prefix => "incomplete")
    end
    self.link_type = type 
  end

  def link_type_name
    no_link_type? ? nil : link_type.name
  end

  private 

  def name_or_url_missing?
    self[:name].blank? || self[:url].blank?
  end

  def no_link_type?
    link_type.nil?
  end

end
