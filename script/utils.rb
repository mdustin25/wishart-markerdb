# Class for making joiners for bulk inserts 
# of has_and_belong_to_many associations
#
# To create an instance:
#   joiner = HbtmJoiner.new Book, :pages
# To add an association:
#   joiner.add :book => book_instance, :page => page_instance
#
# Or:
#   joiner.add :book_id => book_instance.id, :page_id => page_instance.id
#   
#
# To run the bulk insert:
#   joiner.go!
#
# To see the sql that it is running:
#   joiner.to_sql
class HbtmJoiner

  def initialize(owner,association)
    reflection =  owner.reflect_on_association(association)
    @join_table = reflection.options[:join_table]
    @primary_key_name = reflection.primary_key_name
    @primary_name = owner.name.underscore.to_sym
    @association_foreign_key = reflection.association_foreign_key
    @foreign_name = reflection.klass.name.underscore.to_sym
    @values = ""
  end

  def clear_values
    @values = ""
  end

  def go!
    unless @values.empty?
      ActiveRecord::Base.connection.execute(to_sql)
      @values = ""
    end
  end

  def to_sql
    "INSERT INTO `#{@join_table}` 
      (`#{@primary_key_name}`,`#{@association_foreign_key}`)
      VALUES #{@values}"
  end

  def add(options = {})
    unless options[@primary_name].nil?
      primary_value = options[@primary_name].id
    end
    primary_value ||= options[@primary_key_name.to_sym] 
    
    unless options[@foreign_name].nil?
      foreign_value = options[@foreign_name].id
    end
    foreign_value ||= options[@association_foreign_key.to_sym]

    if primary_value.nil? or foreign_value.nil?
      raise "Must supply values for #{@primary_key_name} 
        and #{@association_foreign_key}"
    end

    @values << "," unless @values.empty?
    @values << "(#{primary_value},#{foreign_value})"
  end
end



class ScrapeTimer
  DEFAULT_INTERVAL = 1.0 / 3.0
  
  def initialize( default_interval = DEFAULT_INTERVAL )
    @default_interval = default_interval
    @last_access = nil
    @last_access_mutex = nil
  end

  # Sleeps until allowed to access.
  # ---
  # *Arguments*:
  # * (required) _wait_: wait unit time
  # *Returns*:: (undefined)
  def access_wait(wait = @default_interval)
    @last_access_mutex ||= Mutex.new
    @last_access_mutex.synchronize {
      if @last_access
        duration = Time.now - @last_access
        if wait > duration
          sleep wait - duration
        end
      end
      @last_access = Time.now
    }
    nil
  end
end
