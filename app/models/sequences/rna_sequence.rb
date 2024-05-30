class RnaSequence < Sequence
  validates :chain, format: { with: /\A[ACUG]+\z/ }
end
