class RenameColumnsFromTypeToOtherName < ActiveRecord::Migration
  def self.up
    # not allowed to call columns the name type! that is 
    # reserved for polymorphic relations
    rename_column :protein_bms, :type, :protein_type
    rename_column :molecule_bms, :type, :molecule_type
    rename_column :genetic_bms, :type, :genetic_type
    rename_column :alleles, :type, :allele_type
  end

  def self.down
    rename_column :alleles, :allele_type, :type
    rename_column :genetic_bms, :genetic_type, :type
    rename_column :molecule_bms, :molecule_type, :type
    rename_column :protein_bms, :protein_type, :type
  end
end
