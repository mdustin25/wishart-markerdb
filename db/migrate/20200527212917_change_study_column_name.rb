class ChangeStudyColumnName < ActiveRecord::Migration
  def change
    rename_column :single_nucleotide_polymorphisms, :gwas_rocs_id, :study_id
  end
end
