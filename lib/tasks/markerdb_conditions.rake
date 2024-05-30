namespace :condition do 
	desc "update condition names to standardize all of it to sentence case"
  task :update_cond_name => [:environment] do |t|
    # standardized condition name
    Condition.transaction do
      all_cond = Condition.all
      all_cond.each do |each_cond|
        # Right now conditions has no validations, ignore anything that is not exported
        unless each_cond.exported == false
          # strip all spaces and make sure it is spaced properly
          standardized_name = each_cond.name.strip.split().join(" ")
          standardized_name = standardized_name.titleize
          each_cond.name = standardized_name
          each_cond.save!
        end
      end
    end
  end
  
	desc "will merge the first condition into the 2nd one (Export the 2nd, unexport the 1st)"
	task :merge_dup_conditions, [:infile] => [:environment] do |t,args|
		file_ptr = File.open(args[:infile],'r')
    cont = file_ptr.readlines()
    header = cont.shift()
    puts(header)
    # will either make all the changes or none if anything is not updated properly
    Condition.transaction do
      cont.each do |line|
        line = line.strip()
        line_elem = line.split("\t")
        unexport_cond = Condition.where("id = ?",line_elem[0])
        export_cond = Condition.where("id=?",line_elem[1])
        # export what we want and unexport what we don't want
        export_cond.exported = true
        export_cond.save!

        unexport_cond.exported = false
        unexport_cond.save!
        # if the exported one doesn't have description to begin with, now it does..
        if (export_cond.description == nil and unexport_cond.description != nil)
          m_cond.description = condition.description
        # if both have description we check length and export the longer one, hide the shorter one
        elsif (export_cond.description != nil and unexport_cond.description != nil)
          if (export_cond.description.length < unexport_cond.description.length)
            short_desc = export_cond.description
            export_cond.description = unexport_cond.description
            unexport_cond.description = short_desc
          end
        end

        # relinking condition categories
        # for all categories that this condition belongs to
        unexport_cond.categories.each do |category|
          # remove the association to the duplicated conditions
          category.conditions.destroy(unexport_cond)
          # if the master duplication not already linked, will create link
          unless category.conditions.include?(export_cond)
            category.conditions << export_cond
          end
        end

        # relinking extra_descriptions
        unexport_cond.extra_descriptions.each do |e_desc|
          e_desc.describable_id = export_cond.id
          e_desc.save!
        end

        # re-linking superconditions if it has any
        # # changing the ids
        
        unless unexport_cond.super_condition_id == nil
          export_cond.super_condition_id = unexport_cond.super_condition_id
          unexport_cond.super_condition_id = nil
        end
        # re-linking subconditions
        # # any condition whose super_condition_id is the old one, change it to the new
        all_sub_conds = Condition.where("super_condition_id = ?",unexport_cond.id)
        all_sub_conds.each do |sub_cond|
          sub_cond.super_condition_id = export_cond.id
          sub_cond.save!
        end
          
        # obtain all concentration for this condition and link it to new one if there are any
        all_measurements_res = unexport_cond.all_measurements
        unless all_measurements_res[:concentrations].blank?
          all_measurements_res[:concentrations].each do |concentration|
            concentration.condition_id = export_cond.id
            concentration.save!
          end
        end

        # same idea as concentration but for sequence variants
        seq_variants = SequenceVariant.where("condition_id = ?",unexport_cond.id)
        seq_variants.each do |seq_variant|
          seq_variant.condition_id = export_cond.id
          seq_variant.save!
        end

        # update aliases
        unexport_cond.aliases.each do |cond_alias|
          cond_alias_alphanum = cond_alias.name.gsub(/[^0-9a-z]/i, '').downcase
          matched = false
          export_cond.aliases.each do |m_cond_alias|
            m_cond_alias_alphanum = m_cond_alias.name.gsub(/[^0-9a-z]/i, '').downcase
            if (cond_alias_alphanum == m_cond_alias_alphanum)
              matched = true
              break
            end
          end
          # if this alias matches to an existing one, then this is just extra
          # if this alias does not match to an existing one, then will add it to it
          if matched
            cond_alias.aliasable_id = nil
            cond_alias.aliasable_type = nil
            cond_alias.save!
          else
            cond_alias.aliasable_id = export_cond.id
            cond_alias.save!
          end
        end

        # update external links like above
        unexport_cond.external_links.each do |e_link|
          e_link.linkable_id = export_cond.id
          e_link.save!
        end

        # update citations (and references as well)
        unexport_cond.citations.each do |citation|
          citation.citation_owner_id = export_cond.id
          citation.save!
        end
        # update karyotype_indication links
        kary_inds = KaryotypeIndication.where("condition_id = ?",unexport_cond.id)
        kary_inds.each do |kary_ind|
          # puts(kary_ind.condition_id)
          kary_ind.condition_id = export_cond.id
          kary_ind.save!
        end
        unexport_cond.save!
        export_cond.save!
  		end
    end
	end
end