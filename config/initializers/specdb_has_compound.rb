module Specdb
  module HasCompound 
    extend ActiveSupport::Concern

    # This method uses the inchi_key in the result to look 
    # up the compound in the app. The compound
    def compound
      compound = Specdb.config.compound_class.
        where( Specdb.config.inchi_key_column => inchi_key ).first

      # Wrap the compound object with a compound_decorator that
      # adds the ability to call the moldb_methods with or without the
      # moldb_ prefix
      compound.nil? ? nil : CompoundDecorator.new(compound)
    end

  end
end
