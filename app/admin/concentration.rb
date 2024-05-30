ActiveAdmin.register Concentration do
  filter :mean
  filter :solute_type


  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  permit_params :age_range, :level, :location_name, :special_constraints,
    :sex, :biofluid, :comment, :range, :high, :low, :mean,
    :units, :pvalue, :condition_id, :indication_type_id,
    :biomarker_category_id, :indication_modifier,
    :quality_id, :quality_type

  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if resource.something?
  #   permitted
  # end


end
