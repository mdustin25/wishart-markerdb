require 'rubygems'
require 'nokogiri'

class UniprotParser

  def initialize(file_path)
    @file  = File.open(file_path)
  end

  def each_entry
    first = true

    @file.each_line("<entry") do |section|
      (first = false; next) if first
      # remove <entry from end
      section[-6..-1] = ""
      # put entry on start of string
      section = "<entry" + section
      doc = Nokogiri::XML(section)

      yield doc
    end
  end

end

