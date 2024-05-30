class AddQualityToConcentrations < ActiveRecord::Migration
  def change
    Concentration.transaction do
    add_reference :concentrations, :quality, index: true, polymorphic: true
    add_reference :karyotype_indications, :quality, index: true, polymorphic: true
    add_reference :sequence_variant_measurements, :quality, polymorphic: true
    add_index :sequence_variant_measurements, [:quality_id, :quality_type], unique: true, name: "seq_var_measurements_qual_id_qual_type"
    end
  end
end
