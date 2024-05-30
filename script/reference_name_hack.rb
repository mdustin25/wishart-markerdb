class Reference < ActiveRecord::Base
    # hack because references is a mysql keyword
    # and it messes up crewait, namespaceing
    # to database name fixes the problem
    config = Rails.configuration.database_configuration[Rails.env]
    set_table_name  "#{config['database']}.references"
end

