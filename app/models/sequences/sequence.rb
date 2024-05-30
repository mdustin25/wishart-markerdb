class Sequence < ActiveRecord::Base
  belongs_to :sequenceable, polymorphic: true
  
  validates :header, 
    presence: true, 
    uniqueness: { scope: [ :sequenceable_id, :sequenceable_type ] }
  validates :chain, 
    presence: true,
    uniqueness: { scope: [ :sequenceable_id, :sequenceable_type, :header ] }

  before_validation :clean_chain, :clean_header

  attr_accessor :fasta
  
  def fasta
    @fasta ||= self.fasta_sequence
  end
  
  def fasta=(seq)
    match = seq.scan( /\s*>(.+?)(?:\n|\r)(.*)\s*/m )
    if match.present? && match.size == 1
      self.header = match[0][0]
      self.chain  = match[0][1].gsub(/(\s|\r)*/, '')
      @fasta      = self.fasta_sequence
    else
      nil
    end
  end
  
  def fasta_sequence(line_length=60, head=nil)
    seq_header = head.present? ? head : self.header

    if seq_header.present? && self.chain.present?
      seq = self.chain.gsub(/(.{#{line_length}})/, '\1' << "\n")
      ">#{seq_header}\n#{seq}"
    else
      nil
    end
  end
  
  def self.example
    ">Tumor necrosis factor precursor\n
     MSTESMIRDVELAEEALPKKTGGPQGSRRCLFLSLFSFLIVAGATTLFCLLHFGVIGPQR\n
     EEFPRDLSLISPLAQAVRSSSRTPSDKPVAHVVANPQAEGQLQWLNRRANALLANGVELR\n
     DNQLVVPSEGLYLIYSQVLFKGQGCPSTHVLLTHTISRIAVSYQTKVNLLSAIKSPCQRE\n
     TPEGAEAKPWYEPIYLGGVFQLEKGDRLSAEINRPDYLDFAESGQVYFGIIAL"
  end

  private

  def clean_chain
    self.chain = chain.upcase.gsub(/\s/, '') if self.chain.present?
  end
  
  def clean_header
    self.header.sub!(/^>/, '') if self.header.present?
  end
end

# Need to pre-load child classes in development b/c of lazy loading
%w(polypeptide gene rna).each {|r| require_dependency "#{r}_sequence" } if Rails.env.development?
