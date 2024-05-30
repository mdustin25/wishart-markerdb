class CreateBiomarkerConditions < ActiveRecord::Migration
  def self.up
    create_table :biomarker_conditions do |t|
      t.references :biomarker, :polymorphic => true
      t.references :condition
      
      # measure the concentration or an allele, etc.
      t.references :measurement, :polymorphic => true
        
      # |    "64% increase"   | "chance of" |
      # | indication_modifier | indication  |

      # |    "increase"       | "chance of recovery" |
      # | indication_modifier |      indication      |
      t.string     :indication_modifier
      t.references :indication_type
      t.string     :comment

      # TODO consider putting a pvalue here
    end
  end

  def self.down
    drop_table :biomarker_conditions
  end
end
