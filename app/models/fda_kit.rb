class FdaKit < ActiveRecord::Base
  belongs_to :lab_test

    def self.fetch_and_create_for(owner, search_term)
      require 'uri'
      require 'net/http'

      return nil if owner.nil? or search_term.nil?

      url = URI.parse(
        "http://www.accessdata.fda.gov/scripts/" +
        "cdrh/cfdocs/cfivd/IVDExcel.cfm?export=1&" +
        "search_term=#{CGI::escapeHTML(search_term)}"
      )

      # fetch the file
      kits_file = Net::HTTP.get(url)
      rows = kits_file.split("\r\n")
      if rows.shift != "IVD - In Vitro Diagnostics" 
        return nil
      end

      # drop headers
      rows.shift

      # save into database
      kits = []
      rows.each do |row|
        fields = row.split(",")
        date = Date.strptime( fields[3], "%m/%d/%Y")
        kits << self.new(
          :doc_number         => fields[0],
          :company            => fields[1],
          :name               => fields[2],
          :approved_date      => date,
          :lab_test    => owner
        )
      end

      FdaKit.import( kits )

    end


end

# == Schema Information
#
# Table name: fda_kits
#
#  id            :integer(4)      not null, primary key
#  doc_number    :string(255)
#  company       :string(255)
#  name          :string(255)
#  approved_date :date
#  lab_test_id   :integer(4)
#

