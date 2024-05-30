module UrlHelper
  def moldb_url(object,type=nil)
    if type.nil? || type == :image_full
      "http://moldb.wishartlab.com/molecules/#{object.moldb_inchikey}/image.png"
    elsif type == :thumb
      "http://moldb.wishartlab.com/molecules/#{object.moldb_inchikey}/thumb.png"
    elsif type == :mol
      "http://www.hmdb.ca/structures/structures/metabolites/#{object.hmdb}.mol"
    elsif type == :sdf
      "http://www.hmdb.ca/structures/structures/metabolites/#{object.hmdb}.sdf"
    end
  end

  def biomarker_category_path(category_name)
    category_name = category_name.to_s
    unless BiomarkerCategoriesController::CATEGORIES.include? category_name
      raise ArgumentError, "Biomarker category must be one of [#{BiomarkerCategoriesController::CATEGORIES.join(", ")}]"
    end

    "/categories/#{category_name}"
  end

end
