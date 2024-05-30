class ExpandKaryotype < ActiveRecord::Migration
  def change
    add_column :karyotype_indications, :gene_list, :text
    add_column :karyotype_indications, :age, :text
    add_column :karyotype_indications, :sex, :text
    add_column :karyotype_indications, :citation, :text
    add_column :karyotype_indications, :exported, :text
  end
end
