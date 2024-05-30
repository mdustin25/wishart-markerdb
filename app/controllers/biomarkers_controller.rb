class BiomarkersController < ApplicationController
  def show

  end

  def index 
    @biomarkers = Gene.page(params[:page])
    #@biomarkers = (Gene.all + Protein.all + Chemical.all).
      #sort!{|t1,t2|t1.name <=> t2.name}.paginate(:page => params[:page]) 
  end
end
