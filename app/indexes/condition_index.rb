class ConditionIndex
  include Unearth::Index::Indexable

  set_index_name 'conditions'

  # Scopes that are used to build the index.
  def self.indexed_document_scopes
    [ Condition.exported ]
  end

  mapping do
    indexes :id, type: :keyword
    indexes :name, type: :keyword, boost: 300
    indexes :synonyms, as: Proc.new{ try(:names) }, type: :text
    indexes :description, type: :text
    
    indexes_with_exact :name, type: :text
  end



end
