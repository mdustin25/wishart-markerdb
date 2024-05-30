class PolypeptideSequence < Sequence
  validates_format_of :chain, with: /\A[GAVLIMFWPSTCYNQDEKRHXU]+\z/,
    message: 'is not a valid protein sequence'
  # convert all sequences to short form
  before_validation do
    amino_acid_dictionary = { 'Ala' => 'A', 'Arg' => 'R', 'Asn' => 'N', 'Asp' => 'D', 'Cys' => 'C', 'Glu' => 'E',
                              'Gln' => 'Q', 'Gly' => 'G', 'His' => 'H', 'Ile' => 'I', 'Leu' => 'L', 'Lys' => 'K',
                              'Met' => 'M', 'Phe' => 'F', 'Pro' => 'P', 'Ser' => 'S', 'Thr' => 'T', 'Trp' => 'W',
                              'Tyr' => 'Y', 'Val' => 'V', 'Sec' => 'U' }
    amino_acid_dictionary.each_pair do |long_form, short_form|
      self.chain.gsub!(/#{long_form}/, short_form) if !self.chain.blank?
    end
  end
end