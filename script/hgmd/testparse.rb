require 'rubygems'
require 'mechanize'

agent = Mechanize.new
login_page = agent.get("http://www.hgmd.cf.ac.uk/docs/login.html")

# login
home_page = login_page.form_with(:action => "../ac/validate.php" ) do |f|
  f['email']    = "mwilson1@ualberta.ca"
  f['password'] = '777086' 
  f['country']  = "Canada"
end.click_button

# get the index page for a gene
#page = agent.get("http://www.hgmd.cf.ac.uk/ac/gene.php?gene=BRCA1")
# get the forms to go to different pages
#mutation_pages = page.forms_with(:action => "all.php" )

# go to a page for a specific mutation type
# and specific gene
#
  # the other possible databases are
  # home.search('select[@name = "database"] option').map{|x| x.content.strip}
  # ["Missense/nonsense", 
  # "Splice", 
  # "Regulatory", 
  # "Small deletions", 
  # "Small insertions", 
  # "Small indels", 
  # "Gross deletions", 
  # "Gross insertions", 
  # "Complex rearrangements", 
  # "Repeat variations", 
  # "Summary"]
page = agent.post(
  "http://www.hgmd.cf.ac.uk/ac/all.php", 
  :gene => "BRCA1", 
  :database => "Missense/nonsense"
)

# find the table of mutations
table = nil
page.search("td").each do |cell| 
  if cell.content == "Accession Number"
    table = cell.parent.parent
    break
  end
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
          cell.inner_html =~ /list_uids=(\d+)/
          $1
        else
          cell.content
        end
    end
    yield cells
  end
end

parse_rows(table) do |row|
  puts row
  exit 
end


