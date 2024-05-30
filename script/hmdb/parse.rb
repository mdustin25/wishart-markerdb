# this is a script for parsing the metabocard
# flatfile from hmdb
require './script/hmdb/hmdb_util'
require 'crewait'
require './script/utils'

file_path = ARGV[0]
raise "No file given" if file_path.nil?

# set up class for parsing the cards 
class ParseMetabocards
  # set up constants
  NA = "Not Available"
  NORMAL = Condition.find_by_name "Normal"

  def initialize
    @created_conditions = {}
    @created_references = {}
    @waiting_list = []
    
    # make the object to store the crewaited objects
    Crewait.start_waiting
    @level_references = HbtmJoiner.new(MoleculeLevel, :references)
    @bm_references = HbtmJoiner.new(MoleculeBm, :references)

    @waiting_list += [Crewait,@level_references,@bm_references]
  end

  # call this method to parse a metabocard
  # and crewait objects from it
  def parse_card(card)
    bm = make_bm(card)
    add_aliases(card,bm)
    add_references(card,bm)
    add_links(card,bm)
    add_concentration_levels(card,bm)
  end

  # call this method to import the crewaited
  # objects into the db
  def go!
    @waiting_list.each do |crewaiter|
      crewaiter.go!
    end
  end

  private

  def add_links(card,bm)
    make_link card, "BioCyc", :biocyc_id, bm
    make_link card, "BiGG", :bigg_id, bm
    make_link card, "KEGG", :kegg_compound_id, bm 
    make_link card, "HMDB", :hmdb_id, bm
  end

  def add_aliases(card,bm)
    unless card.synonyms.nil?
      aliases =  card.synonyms.split(";")
      aliases.each do |a|
        a.strip!
        unless a.empty? or (a =~ /^null$/i ) 
          MoleculeBmAlias.crewait(
            :name => a,
            :molecule_bm_id => bm.id,
          )
        end
      end
    end
  end

  def add_concentration_levels(card,bm)
    # add each of the concentration levels
    card.concentrations.each do |conc|

      condition = make_condition(conc)

      attributes = {
        :level => "#{conc.concentration} #{conc.units}",
        :biofluid => conc.biofluid,
        :sex =>  conc.sex,
        :age_range => conc.age,
        :condition_id => condition.id, 
        :molecule_bm_id => bm.id,
      }
      unless conc.comments == NA
        attributes[:comment] = conc.comments
      end
      level = MoleculeLevel.crewait(attributes)

      make_level_references(level,conc)
    end 
  end


  def add_references(card,bm)
    unless card.general_references.nil?
      references = [card.general_references].flatten
      references.each do |ref_string|
        pubmed_id,citation = ref_string.split /[|]/
          @bm_references.add(
            :molecule_bm => bm, 
            :reference => reference_find_or_crewait(citation, pubmed_id)
        )
      end                    
    end
  end

  def make_condition(conc)
    condition_name = conc.disorders
    condition = nil
    if conc.patient_status == "normal"
      condition = NORMAL
    else
      condition = @created_conditions[condition_name]
      condition ||= Condition.find_by_name condition_name
      if condition.nil?
        condition = Condition.crewait( :name => condition_name )
        @created_conditions[condition_name] = condition
      end
    end
    condition
  end

  def make_level_references(level,conc)
    unless (conc.references.nil? or conc.references.empty? ) 
      pubmed_id,citation = conc.references.split /[|]/

        @level_references.add(
          :molecule_level => level, 
          :reference => reference_find_or_crewait(citation, pubmed_id)
      )
    end                    
  end

  def make_link(card,name,link_attribute,bm)
    link = card.send(link_attribute)
    unless link == NA
      MoleculeBmLink.crewait(
        :name => name, 
        :link => link, 
        :molecule_bm_id => bm.id
      )
    end
  end

  def make_bm(card)
    MoleculeBm.crewait(
      :name => card.name,
      :description => card.description,
      :iupac => card.iupac,
      :hmdb => card.hmdb_id,
      :chemical_formula => card.chemical_formula,
    ) 
  end

  def reference_find_or_crewait(citation,pubmed_id)
    ref = @created_references[citation]
    #ref ||= Reference.find_by_citation(citation)
    ref ||= Reference.search(citation).first

    if ref.nil?
      ref_attributes = { :citation => citation }
      ref_attributes[:pubmed_id] = pubmed_id unless pubmed_id.nil?
      ref = Reference.crewait(ref_attributes)
      @created_references[citation] = ref
    end
    ref
  end
end


parser = ParseMetabocards.new

load_cards_from_yaml file_path do |card|
  parser.parse_card card
end

class Reference < ActiveRecord::Base
    # hack because references is a mysql keyword
    # and it messes up crewait, i will fix crewait
    # sometime, just need to use backticks
    # adding database name to fix the problem
    config = Rails.configuration.database_configuration[Rails.env]
    set_table_name  "#{config['database']}.references"
end


parser.go!

