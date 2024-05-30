class GeneSequence < Sequence
  validates :chain, format: { with: /\A[ACTGN]+\z/ }
  validates :chain, 
    presence: true,
    uniqueness: { scope: [ :sequenceable_id, :sequenceable_type, :header ] }
end