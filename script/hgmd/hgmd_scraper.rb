# This file contains a class for scraping data from
# HGMD, it is quick and dirty and not well tested
# but it works the login info is in the code directly
# and it doesn't check to make sure it works
#
# to use:
# hgmd = HgmdScraper.new
# hgmd.splice("brca1"){|row| puts row["Accession Number"];}
#
# each row yields a hash with header_name => cell_value 
# like below (but may be different for each db):
#
# {"Accession Number"=>"CS033832", 
# "IVS"=>"23", 
# "Donor/Acceptor"=>"ds", 
# "Location"=>"+8", 
# "Substitution"=>"G-T", 
# "Phenotype"=>"Breast cancer ?", 
# "Reference"=>"12624724", 
# "Comments"=>""}

require 'rubygems'
require 'mechanize'
require './script/utils.rb'

class HgmdScraper

  def initialize
    @agent = Mechanize.new
    @timer = ScrapeTimer.new
    @timer.access_wait
    login_page = @agent.get("http://www.hgmd.cf.ac.uk/docs/login.html")

    # login
    home_page = login_page.form_with(:action => "../ac/validate.php" ) do |f|
      f['email']    = "mwilson1@ualberta.ca"
      f['password'] = '777086' 
      f['country']  = "Canada"
    end.click_button
  end


  # this hash defines the names of the available databases
  # and the methods to access them
  DATABASES = {
   :missense     => "Missense/nonsense", 
   :splice       => "Splice", 
   :regulatory   => "Regulatory", 
   :small_del    => "Small deletions", 
   :small_ins    => "Small insertions", 
   :small_indel  => "Small indels", 
   :gross_del    => "Gross deletions", 
   :gross_ins    => "Gross insertions", 
   :complex_rear => "Complex rearrangements", 
   :repeat_var   => "Repeat variations", 
   #"Summary"
  }

  # make functions for all the database types
  # from the keys in the DATABASES hash
  DATABASES.keys.each do |database|
    class_eval <<-DEFINE
      def #{database}(gene,&block)
        table = fetch_mutation_table(gene, :#{database})
        parse_rows(table, &block) unless table.nil?
      end
    DEFINE
  end

  def databases
    DATABASES
  end

  private

  # get the table of mutations for a gene and database type
  # returns nil if not found
  def fetch_mutation_table(gene,database)
    @timer.access_wait
    page = @agent.post(
      "http://www.hgmd.cf.ac.uk/ac/all.php", 
      :gene => gene.upcase, 
      :database => DATABASES[database]
    )

    # find the table of mutations
    page.search("td").each do |cell| 
      if cell.content == "Accession Number"
        return cell.parent.parent
      end
    end
    nil
  end

  # parse the rows and return a hash with {table_header => cell_value}
  def parse_rows(table)
    rows     = table.children
    headings = rows.shift.children.map{ |cell| cell.content }.each

    rows.each do |row|
      headings.rewind
      cells = {}
      row.children.each do |cell|
        heading = headings.next
        cells[heading] = 
          if heading == "Reference"
            cell.inner_html =~ /list_uids=(\d+)/ and $1 
          else
            cell.content
          end
      end
      yield cells
    end
  end

end
