class ChangeExternalIdToUrl < ActiveRecord::Migration
  def change
    remove_column :sequence_variants, :external_id
    add_column :sequence_variants, :external_url, :text
  end
end
