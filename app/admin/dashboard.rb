ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: "MarkerDB Dashboard" do

    # Here is an example of a simple dashboard with columns and panels.
    #
     columns do
       #column do
         #panel "Recent Posts" do
           #ul do
             #Post.recent(5).map do |post|
               #li link_to(post.title, admin_post_path(post))
             #end
           #end
         #end
       #end

       column do
         panel "Database Stats" do
           table do
             thead do
               tr do
                 th "Item"
                 th "Count"
               end
             end
             tbody do
               tr do
                 td "Concentrations"
                 td Concentration.count
               end
               tr do
                 td "Metabolites"
                 td  Chemical.count
               end
               tr do
                 td "Proteins"
                 td  Protein.count
               end
               tr do
                 td "Genes"
                 td Gene.count
               end
               tr do
                 td "References"
                 td Reference.count
               end
               tr do
                 td "Indication Types"
                 td do
                   IndicationType.pluck(:indication).join(", ")
                 end
               end
               tr do
                 td "Biomarker Categories"
                 td do
                   BiomarkerCategory.pluck(:name).join(", ")
                 end
               end
             end
           end
         end
       end
     end
  end # content
end
