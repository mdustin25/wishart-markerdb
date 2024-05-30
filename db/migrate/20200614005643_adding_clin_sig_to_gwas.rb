class AddingClinSigToGwas < ActiveRecord::Migration
  def change
    add_column :single_nucleotide_polymorphisms, :clin_sig, :text
  end
end
