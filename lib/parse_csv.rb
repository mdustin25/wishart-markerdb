require 'csv'

     
class Parse_csv

  def initialize(filename)
       @file = File.open(filename, mode='r')
  end
  
  def parse
    table = CSV.parse(@file, headers:true)
  end
end       
