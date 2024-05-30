class BiomarkerCategoriesController < ApplicationController
  include Unearth::Filters::Filterable
  require 'will_paginate/array'
  CATEGORIES = %w[ diagnostic prognostic predictive exposure monitoring ]
  respond_to :html

  WillPaginate.per_page = 30

  filter_by_groups :biomarker_type, :exposure_biomarker


  def index
    @category = params[:marker_category]

    # Only allow the defined categories
    unless CATEGORIES.include? @category
      raise ActionController::RoutingError.new('Not Found')
    end
    @all_markers = apply_relation_filters(Hash.new)
    # puts "@all_markers.length => #{@all_markers.length}" # 4044 for predictive

    unless params[:d].nil?
      if params[:d] == "up"
        if params[:c] == "Biomarker Name"
          @all_markers = Hash[@all_markers.sort_by{|k, v| v[0]["biomarker_name"]}]
        else
          @all_markers = Hash[@all_markers.sort_by{|k, v| v[0]["mdbid"]}]
        end
      else
        if params[:c] == "Biomarker Name"
          @all_markers = Hash[@all_markers.sort_by{|k, v| v[0]["biomarker_name"]}.reverse]
        else
          @all_markers = Hash[@all_markers.sort_by{|k, v| v[0]["mdbid"]}.reverse]
          # @sorted_markers = @all_markers.sort_by{|k| k["mdbid"]}.reverse
        end
      end
    end

    # to get the number of page, just get the number of elements (i.e., number of keys)
    @sorted_page_num = @all_markers.to_a.paginate(:page => params[:page])
    @cond_categories = ConditionCategory.order(:name).select(:name)
  end




  def diagnostic

    filtered_biomarker = []

    if params[:filter]

      params.each do |item, value|
        value_c = value.to_i
        if item == "chemical" and value_c == 1
          filtered_biomarker << "Chemical"
        elsif item == "protein" and value_c == 1
          filtered_biomarker << "Protein"
        elsif item == "karyotype" and value_c == 1
          filtered_biomarker << "Karyotype"
        elsif item == "sequence_variant" and value_c == 1
          filtered_biomarker << "SequenceVariant"
        end
      end
    end

    if filtered_biomarker.length > 0

      suppose_count = BiomarkerCategoryMembership.where(:biomarker_category_id => 2, :biomarker_type => filtered_biomarker).select("distinct biomarker_id, biomarker_type").count

      if params[:d] == "up"
        @result = BiomarkerCategoryMembership.where(:biomarker_category_id => 2, :biomarker_type => filtered_biomarker).select("distinct biomarker_id, biomarker_type").paginate(:page => params[:page], :total_entries => suppose_count).order(params[:c])
      elsif params[:d] == "down"
        @result = BiomarkerCategoryMembership.where(:biomarker_category_id => 2, :biomarker_type => filtered_biomarker).select("distinct biomarker_id, biomarker_type").paginate(:page => params[:page], :total_entries => suppose_count).order(params[:c]).reverse_order
      else
        @result = BiomarkerCategoryMembership.where(:biomarker_category_id => 2, :biomarker_type => filtered_biomarker).select("distinct biomarker_id, biomarker_type").paginate(:page => params[:page], :total_entries => suppose_count)
      end
        
    else
      suppose_count = BiomarkerCategoryMembership.where(:biomarker_category_id => 2).select("distinct biomarker_id, biomarker_type").count
      if params[:d] == "up"
        @result = BiomarkerCategoryMembership.where(:biomarker_category_id => 2).select("distinct biomarker_id, biomarker_type").paginate(:page => params[:page], :total_entries => suppose_count).order(params[:c])
      elsif params[:d] == "down"
        @result = BiomarkerCategoryMembership.where(:biomarker_category_id => 2).select("distinct biomarker_id, biomarker_type").paginate(:page => params[:page], :total_entries => suppose_count).order(params[:c]).reverse_order
      else
        @result = BiomarkerCategoryMembership.where(:biomarker_category_id => 2).select("distinct biomarker_id, biomarker_type").paginate(:page => params[:page], :total_entries => suppose_count)
      end      
    end

    biomarker_hash = Hash.new
    @result.each do |marker|
      key = {
             "biomarker_id" => marker.biomarker_id,
             "biomarker_type" => marker.biomarker_type
            }

      biomarker_hash[key] = []

      partial_biomarker = BiomarkerCategoryMembership.where(:biomarker_category_id => 2, :biomarker_id => marker.biomarker_id, :biomarker_type => marker.biomarker_type)      

      partial_biomarker.each do |partials|
        biomarker_hash[key] << {
                                "biomarker_name" => partials.biomarker_name,
                                "mdbid" => partials.mdbid,
                                "condition_id" => partials.condition_id,
                                "condition_name"=> partials.condition_name
                                }

      end

    end

    @all_markers = biomarker_hash.to_a
    @cond_categories = ConditionCategory.order(:name).select(:name)

  end

  def predictive
    filtered_biomarker = []

    if params[:filter]

      params.each do |item, value|
        value_c = value.to_i
        if item == "chemical" and value_c == 1
          filtered_biomarker << "Chemical"
        elsif item == "protein" and value_c == 1
          filtered_biomarker << "Protein"
        elsif item == "karyotype" and value_c == 1
          filtered_biomarker << "Karyotype"
        elsif item == "sequence_variant" and value_c == 1
          filtered_biomarker << "SequenceVariant"
        end
      end
    end

    if filtered_biomarker.length > 0

      suppose_count = BiomarkerCategoryMembership.where(:biomarker_category_id => 1, :biomarker_type => filtered_biomarker).select("distinct biomarker_id, biomarker_type").count

      if params[:d] == "up"
        @result = BiomarkerCategoryMembership.where(:biomarker_category_id => 1, :biomarker_type => filtered_biomarker).select("distinct biomarker_id, biomarker_type").paginate(:page => params[:page], :total_entries => suppose_count).order(params[:c])
      elsif params[:d] == "down"
        @result = BiomarkerCategoryMembership.where(:biomarker_category_id => 1, :biomarker_type => filtered_biomarker).select("distinct biomarker_id, biomarker_type").paginate(:page => params[:page], :total_entries => suppose_count).order(params[:c]).reverse_order
      else
        @result = BiomarkerCategoryMembership.where(:biomarker_category_id => 1, :biomarker_type => filtered_biomarker).select("distinct biomarker_id, biomarker_type").paginate(:page => params[:page], :total_entries => suppose_count)
      end
        
    else
      suppose_count = BiomarkerCategoryMembership.where(:biomarker_category_id => 1).select("distinct biomarker_id, biomarker_type").count
      if params[:d] == "up"
        @result = BiomarkerCategoryMembership.where(:biomarker_category_id => 1).select("distinct biomarker_id, biomarker_type").paginate(:page => params[:page], :total_entries => suppose_count).order(params[:c])
      elsif params[:d] == "down"
        @result = BiomarkerCategoryMembership.where(:biomarker_category_id => 1).select("distinct biomarker_id, biomarker_type").paginate(:page => params[:page], :total_entries => suppose_count).order(params[:c]).reverse_order
      else
        @result = BiomarkerCategoryMembership.where(:biomarker_category_id => 1).select("distinct biomarker_id, biomarker_type").paginate(:page => params[:page], :total_entries => suppose_count)
      end      
    end

    biomarker_hash = Hash.new
    @result.each do |marker|
      key = {
             "biomarker_id" => marker.biomarker_id,
             "biomarker_type" => marker.biomarker_type
            }

      biomarker_hash[key] = []

      partial_biomarker = BiomarkerCategoryMembership.where(:biomarker_category_id => 1, :biomarker_id => marker.biomarker_id, :biomarker_type => marker.biomarker_type)      

      partial_biomarker.each do |partials|
        biomarker_hash[key] << {
                                "biomarker_name" => partials.biomarker_name,
                                "mdbid" => partials.mdbid,
                                "condition_id" => partials.condition_id,
                                "condition_name"=> partials.condition_name
                                }
                                
      end

    end

    @all_markers = biomarker_hash.to_a
    @cond_categories = ConditionCategory.order(:name).select(:name)

  end

  def exposure
    filtered_biomarker = []

    if params[:filter]

      params.each do |item, value|
        value_c = value.to_i
        if item == "allchemical" and value_c == 1
          filtered_biomarker << "AllChemical"
        elsif item == "food" and value_c == 1
          filtered_biomarker << "Food"
        elsif item == "toxic" and value_c == 1
          filtered_biomarker << "Toxic"
        end
      end
    end

    if filtered_biomarker.length > 0
      if filtered_biomarker.include? "Food" and filtered_biomarker.include? "Toxic"
        suppose_count = BiomarkerCategoryMembership.where(:biomarker_category_id => 4).select("distinct biomarker_id, biomarker_type").count
      elsif filtered_biomarker.include? "Food"
        suppose_count = BiomarkerCategoryMembership.where("biomarker_category_id = ? and condition_name like ?", 4, "%consumption%").select("distinct biomarker_id, biomarker_type").count
      elsif filtered_biomarker.include? "Toxic"
        suppose_count = BiomarkerCategoryMembership.where("biomarker_category_id = ? and condition_name not like ?", 4, "%consumption%").select("distinct biomarker_id, biomarker_type").count
      else
        suppose_count = BiomarkerCategoryMembership.where(:biomarker_category_id => 4).select("distinct biomarker_id, biomarker_type").count
      end
      
      if params[:d] == "up"
        @result = BiomarkerCategoryMembership.where(:biomarker_category_id => 4, :biomarker_type => filtered_biomarker).select("distinct biomarker_id, biomarker_type").paginate(:page => params[:page], :total_entries => suppose_count).order(params[:c])
      elsif params[:d] == "down"
        @result = BiomarkerCategoryMembership.where(:biomarker_category_id => 4, :biomarker_type => filtered_biomarker).select("distinct biomarker_id, biomarker_type").paginate(:page => params[:page], :total_entries => suppose_count).order(params[:c]).reverse_order
      else
        if filtered_biomarker.include? "Food" and filtered_biomarker.include? "Toxic"
          @result = BiomarkerCategoryMembership.where(:biomarker_category_id => 4).select("distinct biomarker_id, biomarker_type").paginate(:page => params[:page], :total_entries => suppose_count).order(params[:c])
        elsif filtered_biomarker.include? "Food"
          @result = BiomarkerCategoryMembership.where("biomarker_category_id = ? and condition_name like ?", 4, "%consumption%").select("distinct biomarker_id, biomarker_type").paginate(:page => params[:page], :total_entries => suppose_count).order(params[:c])
        elsif filtered_biomarker.include? "Toxic"
          @result = BiomarkerCategoryMembership.where("biomarker_category_id = ? and condition_name not like ?", 4, "%consumption%").select("distinct biomarker_id, biomarker_type").paginate(:page => params[:page], :total_entries => suppose_count).order(params[:c])
        else
          @result = BiomarkerCategoryMembership.where(:biomarker_category_id => 4).select("distinct biomarker_id, biomarker_type").paginate(:page => params[:page], :total_entries => suppose_count).order(params[:c])
        end
      end
        
    else
      suppose_count = BiomarkerCategoryMembership.where(:biomarker_category_id => 4).select("distinct biomarker_id, biomarker_type").count
      if params[:d] == "up"
        @result = BiomarkerCategoryMembership.where(:biomarker_category_id => 4).select("distinct biomarker_id, biomarker_type").paginate(:page => params[:page], :total_entries => suppose_count).order(params[:c])
      elsif params[:d] == "down"
        @result = BiomarkerCategoryMembership.where(:biomarker_category_id => 4).select("distinct biomarker_id, biomarker_type").paginate(:page => params[:page], :total_entries => suppose_count).order(params[:c]).reverse_order
      else
        @result = BiomarkerCategoryMembership.where(:biomarker_category_id => 4).select("distinct biomarker_id, biomarker_type").paginate(:page => params[:page], :total_entries => suppose_count)
      end      
    end

    biomarker_hash = Hash.new
    @result.each do |marker|
      key = {
             "biomarker_id" => marker.biomarker_id,
             "biomarker_type" => marker.biomarker_type
            }

      biomarker_hash[key] = []
      partial_biomarker = BiomarkerCategoryMembership.where(:biomarker_category_id => 4, :biomarker_id => marker.biomarker_id, :biomarker_type => marker.biomarker_type)      

      partial_biomarker.each do |partials|
        biomarker_hash[key] << {
                                "biomarker_name" => partials.biomarker_name,
                                "mdbid" => partials.mdbid,
                                "condition_id" => partials.condition_id,
                                "condition_name"=> partials.condition_name
                                }
                                
      end

    end
    @all_markers = biomarker_hash.to_a
    @cond_categories = ConditionCategory.order(:name).select(:name)

  end





end


































