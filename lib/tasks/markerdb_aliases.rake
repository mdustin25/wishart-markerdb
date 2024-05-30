namespace :alias do 
desc "update aliases to standardize all of it to sentence case"
  task :update_alias => [:environment] do |t|
    # check for duplicated alias for all aliasable_type
    # will fix all or none
    puts (Alias.all.length())
    all_aliasable_types = Alias.all.pluck(:aliasable_type).uniq
    Alias.transaction do
      all_aliasable_types.each do |klass|
        unless (klass == nil or klass == "DiagnosticTest")
          puts "working on #{klass}"
          # for each class (e.g., Condition, Genes, etc)
          # it will get all the entries and then get all the associated aliases
          klass.constantize.all.each do |ind_entry|
            ind_entry_name_standardized = ind_entry.name.gsub(/[^0-9a-z]/i, '').downcase.strip
            # keeps tracks of all seen aliases
            seen_aliases = Array.new
            # puts(ind_entry.id)
            ind_entry.aliases.each do |i_e_alias|
              # puts(i_e_alias.name)
              seen = false
              # compare only lowercase alphanumeric
              i_e_alias_standardized = i_e_alias.name.gsub(/[^0-9a-z]/i, '').downcase.strip
              seen_aliases.each do |seen_alias|
                seen_alias_standardized = seen_alias.name.gsub(/[^0-9a-z]/i, '').downcase.strip
                # if it is a duplicate, it will just delete it from the table and be done with this one
                # if an alias is the same as the entry name it is not an alias.
                if (i_e_alias_standardized == seen_alias_standardized or i_e_alias_standardized == ind_entry_name_standardized)
                  seen = true
                  Alias.destroy(i_e_alias)
                  break
                end
              end
              # if it is not seen, it will add the name to seen and titlelize the alias and save it
              unless seen
                seen_aliases << i_e_alias
              end
            end
            # after going through all and deleting duplicated entries
            # these are the ones to keep and will save
            # can't do it before because we could encounter " M6" before "M6" and if this is the case
            # the code will try convert " M6" to "M6" which makes it a duplicate
            seen_aliases.each do |keep_alias|
              # make alias title case and also consistent spacing
              titleize_named = keep_alias.name.strip.titleize
              titleze_named = titleize_named.split().join(" ")
              keep_alias.name = titleize_named
              keep_alias.save!
            end
          end
        end
      end
      all_alias = Alias.all
      # alias database in overall to removce any 'orphaned' aliases
      all_alias.each do |each_alias|
        # remove any alias that is not referencing anything in particular
        # these 'orphaned' alias will be removed
        if each_alias.aliasable_type == nil
          Alias.destroy(each_alias)
        end
      end
    end
    puts (Alias.all.length())
  end
end