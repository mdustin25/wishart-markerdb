# This file contains utilities for parsing hmdb flatfile

require 'rubygems'
require 'progressbar'

WANTED_FIELDS_LIST = %w[
  name
  iupac
  bigg_id
  biocyc_id
  biofluid_location
  cellular_location 
  chemical_formula 
  description
  general_references  
  hmdb_id
  kegg_compound_id 
  omim_id  
  synonyms 
]

# get the cards one at a time from the file
# and put in a hash
def each_card(file_path) 
  file = File.open(file_path)

  wanted_fields = {}
  WANTED_FIELDS_LIST.each do |field|
    wanted_fields[field] = true
  end

  # takes a long time to count length of file so just saveing size
  line_count = 8538 
  progress = ProgressBar.new("Parsing HMDB",line_count)

  until( file.eof? )
    progress.inc

    entry = {}
    line_type = ""
    last_conc_info_type = ""
    last_concentration = {}
    last_disorder_info_type = ""
    last_disorder = {}
    line = ""

    while not line =~ /#END_METABOCARD/ and not file.eof? do 

      line = file.gets      
      return if line.nil?
      
      # fix bad encoding in file
      unless line.valid_encoding?
        line.encode! "UTF-8",  "ISO-8859-1"
      end
      line.strip!

      if line[0] == '#'
        if line =~ /^#(\w+) (HMDB\d+)/
          if $1 == "#BEGIN_METABOCARD"
            entry = {}
            entry["HMDB_id"] = $2
          end
        elsif line =~ /# (\w+):/
          line_type = $1
          if line_type =~ /concentration_(\d+)_(\w+)$/
            index = Integer($1)
            last_conc_info_type = $2
            entry["concentration"] ||= []
            entry["concentration"][index] ||= {}
            last_concentration = entry["concentration"][index]
          elsif line_type =~ /associated_disorder_(\d+)_(\w+)$/
            index = Integer($1)
            last_disorder_info_type = $2
            entry["associated_disorder"] ||= []
            entry["associated_disorder"][index] ||= {}
            last_disorder = entry["associated_disorder"][index]
          end

        end
      elsif not line.empty?
       if not last_conc_info_type.empty?
          last_concentration[last_conc_info_type] ||= []
          last_concentration[last_conc_info_type] << line
        elsif not last_disorder_info_type.empty?
          last_disorder[last_disorder_info_type] ||= []
          last_disorder[last_disorder_info_type] << line
        elsif wanted_fields[line_type]
          entry[line_type] ||= []
          entry[line_type] << line
        end
      else 
        last_concentration  = {}
        last_conc_info_type = ""
        last_disorder_info_type = ""
        last_disorder = {}
      end 
    end
    line = ""

    yield entry
  end
  progress.finish
end

require 'yaml'

# a proxy for the concentration items in
# the HMDBCard to add methods to access 
# the hash items
class HMDBCardCategory

  def initialize(data_hash)
    @data = data_hash
  end

  private

  def access_data(name)
    data = @data[name] 
    if data.nil?
      nil
    elsif data.length <= 1
      data.first
    else
      data
    end
  end

  def method_missing(method, *args, &block)
    if @data.has_key? method.to_s
      access_data(method.to_s)
    else
      @data.send(method, *args, &block)
    end
  end
end

# use the proxy pattern to add some
# methods to the hash from the yaml.load
# but also be able to use it as a hash
class HMDBCard 
  @@wanted_fields_list = WANTED_FIELDS_LIST 

  def initialize(yaml_string)
    @data = YAML.load(yaml_string)
    add_methods
  end

  def concentrations
    access_subcategory "concentration"
  end

  def associated_disorders
    access_subcategory "associated_disorder"
  end
 

  private

  def access_subcategory(name)
    data = @data[name]
    data ||= []
    unless data.length == 0
      data.shift if data.first.nil?
      data = data.collect{|hash| HMDBCardCategory.new(hash)}
    end
    data
  end

  def access_data(name)
    data = @data[name] 
    if data.nil?
      nil
    elsif data.length <= 1
      data.first
    else
      data
    end
  end

  # add methods to access the data in the 
  # hash
  def add_methods
    @@wanted_fields_list.each do |field|
      unless HMDBCard.method_defined? field
        HMDBCard.class_eval %{ 
            def #{field.to_sym} 
              access_data("#{field}")
            end
        }
      end
    end
  end

  # pass missing methods to the hash 
  # we loaded from yaml, so that we behave
  # like a hash
  def method_missing(method, *args, &block)
   @data.send(method, *args, &block)
  end

end

def load_cards_from_yaml(file_path) 
 
  file = File.open file_path
  cards = file.gets(nil).split /^---/

  progress = ProgressBar.new("Reading HMDB cards", cards.size)

  cards.each do |line|
    next if line.empty?

    #card = YAML.load(line)
    card = HMDBCard.new(line)
    yield card

    progress.inc
  end
  
  progress.finish
end

