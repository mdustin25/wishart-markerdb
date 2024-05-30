ActiveAdmin.register Chemical do
  #config.filters = false

   #controller do
     #def scoped_collection
       #super
     #end
   #end

   filter :name
   filter :hmdb

   index do
     column "MarkerDB ID", :to_param
     column :name
     column :hmdb
     #column "Mol. Mass (Da)", :moldb_mono_mass
     actions
   end


   # See permitted parameters documentation:
   # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
   #
   # permit_params :list, :of, :attributes, :on, :model
   #
   # or
   #
   # permit_params do
   #   permitted = [:permitted, :attributes]
   #   permitted << :other if resource.something?
   #   permitted
   # end


end
