class CreateRocStats < ActiveRecord::Migration
  def change
    create_table :roc_stats do |t|
      t.float :roc_auc
      t.float :ci_auc_lower
      t.float :ci_auc_upper
      t.float :sensitivity
      t.float :specificity
      t.integer :participant_count

      t.timestamps
    end
  end
end
