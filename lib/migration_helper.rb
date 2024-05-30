module MigrationHelper
  def add_measurement_columns(table)
    add_column table, :condition_id,          :integer
    add_column table, :indication_type_id,    :integer
    add_column table, :biomarker_category_id, :integer
    add_column table, :indication_modifier,   :string
    add_column table, :comment,               :string
  end

  def remove_measurement_columns(table)
    remove_column table, :comment
    remove_column table, :indication_modifier
    remove_column table, :biomarker_category_id
    remove_column table, :indication_type_id
    remove_column table, :condition_id
  end
end
