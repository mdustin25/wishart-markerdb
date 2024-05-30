require 'migration_helper'

class AddFieldsToMeasurements < ActiveRecord::Migration
  extend MigrationHelper

  def self.up
    add_measurement_columns :concentrations
    add_measurement_columns :sequence_variants
  end

  def self.down
    remove_measurement_columns :sequence_variants
    remove_measurement_columns :concentrations
  end
end
