module Biomarker
  extend ActiveSupport::Concern

  include Linkable
  include CitationOwner
  include LabTestOwner

  included do
    has_many :extra_descriptions,
      :as => :describable,
      :dependent => :destroy
    accepts_nested_attributes_for :extra_descriptions, allow_destroy: true
  end

  def categories; biomarker_categories; end

  # def to_param
  #   mdbid
  # end

  # def mdbid 
  #   Biomarker.id_to_mdbid(id,marker_tag)
  # end
  #TODO replace bmid methods with
  # mdbid
  # def bmid; mdbid; end

  def marker_tag
    self.class.marker_tag
  end

  def type
    self.class.type
  end

  # module ClassMethods 
  #   def set_marker_tag(letter)
  #     @marker_tag = letter.to_s
  #   end
  #   def marker_tag; @marker_tag; end

  #   def set_marker_type(name)
  #     @marker_type = name.to_s
  #   end
  #   def type; @marker_type; end

  #   def find(id,*args)
  #     if id.is_a?(String) && id.match(/\Am[a-z][a-z0-9]{3,5}\z/i)
  #       super Biomarker.mdbid_to_id id, *args
  #     else
  #       super id, *args
  #     end
  #   end

  #   def find_by_mdbid(mdbid,*args)
  #     find mdbid,*args
  #   end
  # end

  # # utility methods

  # # for mapping id to mdbid in base36
  # BASE36 = ("0".."9").to_a + ("A".."Z").to_a
  # BASE10 = Hash.new
  # BASE36.each_with_index{|d,i| BASE10[d.to_s] = i}

  # def self.id_to_mdbid(id,marker_tag)
  #   # convert to base 36
  #   base, num, result = 36, id, ""
  #   while(num != 0)
  #     digit  = num % base
  #     digit  = BASE36[digit]
  #     result = digit + result
  #     num   /= base 
  #   end
  #   # make the id at least 3 digits long
  #   result = (3 - result.length).times.map{"0"}.join + result
  #   "M#{marker_tag}#{result}"
  # end

  # def self.mdbid_to_id(mdbid)
  #   digits = mdbid[2..-1].split //
  #     sum = 0
  #   digits.reverse.each_with_index do |digit,index|
  #     sum += BASE10[digit] * 36**index
  #   end
  #   sum
  # end

  # TODO make it more consolidated by having it just call Biomarker.models and get all class with this
  # # currently for some reason, some classes are missing (seq var for example)
  # returns a list of all the models that include
  # the biomarker module
  def self.models 
    ActiveRecord::Base.descendants.select do |klass|
      klass.include? Biomarker
    end
  end

  # TODO remove this method, instead, all_biomarkers
  # method on condition instance
  #  def self.find_all_biomarkers_by_condition(condition) 
  #    association = self.name.tableize.to_sym
  #    Biomarker.models.select do |model|
  #      case biomarker_model
  #      when Class
  #        biomarker_model == model
  #      when Module
  #        model.include? biomarker_model
  #      else
  #        false
  #      end
  #    end.map do |klass|
  #      klass.joins(association).
  #        where(association => {:condition_id => condition.id}).
  #        group("`#{klass.name.tableize}`.`id`").to_a
  #    end.flatten.uniq
  #  end
  #  def self.find_all_biomarkers_by_condition(condition) 
  #    association = self.name.tableize.to_sym
  #    Biomarker.models.map do |klass|
  #      klass.joins(association).
  #        where(association => {:condition_id => condition.id}).
  #        group("`#{klass.name.tableize}`.`id`").to_a
  #    end.flatten.uniq
  #  end


end
