# this is a script for parsing the ascii version of MESH 
# and createinga list of synonyms

require 'rubygems'
require 'yaml'
require 'progressbar'


# a class to organise our info
class SynonymRecord
  attr_accessor :name, :aliases

  def initialize
    @aliases = []
    @is_disease_entry = false
  end

  def is_disease_entry
    @is_disease_entry = true
  end

  def put(all_syns)
    if @is_disease_entry
      @aliases << @name
      all_syns[@name] = @aliases
    end
  end
end

# class for keeping track of where
# we are in a record
class Context
  IN_RECORD = :in_record
  START_OF_RECORD =:start
  END_OF_RECORD = :end
  NOWHERE = :nowhere

  def initialize
    @context = NOWHERE
  end

  def inRecord?
    @context == IN_RECORD
  end
  
  def atStart?
    @context == START_OF_RECORD
  end

  def atEnd?
    @context == END_OF_RECORD 
  end

  def setContextFromLine(line)
    if line =~ /^\s*$/
      @context = END_OF_RECORD
    elsif line =~ /NEWRECORD/
      @context = IN_RECORD
    end
  end
end

file_path = ARGV[0]
file = File.new(file_path, 'r')
outFile = File.new("MESH_synonyms.yaml","w")

# totals
records = 0
all_synonyms = {}

# for loop
context = Context.new
rec = SynonymRecord.new 

# NOTE wc on linux only
line_count = Integer(%x[wc -l #{file_path}].split(/\s/).first)
progress = ProgressBar.new("Parsing MESH",line_count)

file.each_line("\n") do |line|
  progress.inc

  if context.inRecord?
    type, rest_of_line = line.split( / = / )

    rest_of_line.chomp! unless rest_of_line.nil?   

    if type == 'MH'
      rec.name = rest_of_line
    elsif type == 'ENTRY' or type == 'PRINT ENTRY'
      if line =~ /[|]/
        temp = rest_of_line.split( /[|]/ )
        rec.aliases << temp[0]
      else
        rec.aliases << rest_of_line
      end
    # disease categories start with entry C
    elsif type == 'MN'
      record_type = rest_of_line[0]
      rec.is_disease_entry if record_type == 'C'
    end
  elsif context.atEnd?
    # put the records synonyms into all
    # synonyms.
    # NOTE only adds if it is a disease entry
    rec.put all_synonyms 
    records += 1
    rec = SynonymRecord.new
  end

  context.setContextFromLine line

  #break if records > 4
end

progress.finish
puts "Processed #{records} records"
puts "Outputting"
outFile.write all_synonyms.to_yaml


