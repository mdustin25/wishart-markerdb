module RelatedToSelf 

  # instance methods here
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    # add static methods here
    def is_a_and_has_many(name, options = {}, &extension)
      
      options[:class_name] ||= self.name 
      class_name = self.name.underscore
      plural_name = class_name.pluralize

      options[:join_table] ||= "#{plural_name}_#{plural_name}"
      join_table = options[:join_table]

      options[:foreign_key] ||= "#{class_name}_id".to_sym
      foreign_key = options[:foreign_key]

      options[:association_foreign_key] ||= :related_id
      association_foreign_key = options[:association_foreign_key]


      options[:finder_sql] = <<-SQL
select distinct d.* from 
#{plural_name} d, #{join_table} j 
where (d.id = j.#{association_foreign_key} and j.#{foreign_key} = \#{id}) 
or (d.id = j.#{foreign_key} and j.#{association_foreign_key} = \#{id})
      SQL

      options[:counter_sql] = options[:finder_sql].sub /(distinct d[.][*])/, "count(distinct id)"

      self.has_and_belongs_to_many( name, options, &extension )

      # for now have to make two relations because rails does
      # not handle defining finder sql very well
      forward_options = options.dup
      forward_options[:finder_sql] = nil
      forward_options[:counter_sql] = nil
      forward_name = "#{name.to_s}_forward"
      self.has_and_belongs_to_many( forward_name.to_sym, forward_options, &extension )

      reverse_options = forward_options.dup
      reverse_options[:foreign_key] = forward_options[:association_foreign_key] 
      reverse_options[:association_foreign_key] = forward_options[:foreign_key]
      reverse_name = "#{name.to_s}_reverse"
      self.has_and_belongs_to_many( reverse_name.to_sym, reverse_options, &extension )

      self.class_eval %{
        def #{name.to_s}
          (#{forward_name} + #{reverse_name}).uniq
        end
      }


      #      self.scope :test_scope do 
      #        #{plural_name} d, #{join_table} j 
      #        joins(
      #        where (d.id = j.#{association_foreign_key} and j.#{foreign_key} = \#{id}) 
      #        or (d.id = j.#{foreign_key} and j.#{association_foreign_key} = \#{id})
      #
      #      end

      #      do
      #        def find(id, options={})
      #          if id == :all
      #            proxy_owner.send(:related_tests)
      #          else
      #            proxy_target.find( id,options )
      #          end
      #        end
      #      end

    end
  end
end

# include the extension 
ActiveRecord::Base.send(:include, RelatedToSelf)


