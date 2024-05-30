class CreateRiskStats < ActiveRecord::Migration
  def change
    create_table :risk_stats do |t|
      t.float :frequency
      t.float :relative_risk

      t.timestamps
    end
  end
end
