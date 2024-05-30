module BiomarkersHelper
  # makes biomarker id box
  def bmid( biomarker )
    content_tag :div, biomarker.marker_mdbid.mdbid, :id=>"bmid"
  end

  # Given a biomarker id, uses the correct path helper
  # modified to use the new table sicne we are not using MC, MP, etc but have 1 single id (MDBID000000) for all markers
  def biomarker_path( biomarker_id )
    biomarker_class = MarkerMdbid.where("mdbid = ?",biomarker_id).first.identifiable_type
    case biomarker_class
    when "Chemical"
      main_app.chemical_path(id: biomarker_id)
    when "Protein"
      main_app.protein_path(id: biomarker_id)
    when "Karyotype"
      main_app.karyotype_path(id: biomarker_id)
    when "SequenceVariant"
      main_app.sequence_variant_path(id: biomarker_id)
    end
  end
end
