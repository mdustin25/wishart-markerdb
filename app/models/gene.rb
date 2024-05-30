class Gene < ActiveRecord::Base
  include Aliasable
  include Linkable
  include CitationOwner

  has_many :sequence_variants
  has_many :sequence_variant_measurements, :through => :sequence_variants, 
    :extend => BiomarkerCategoryScopes
  has_many :single_nucleotide_polymorphisms
  
  has_one :marker_mdbid, as: :identifiable
  has_many :gene_sequences, :as => :sequenceable, dependent: :destroy
  has_many :rna_sequences, :as => :sequenceable, dependent: :destroy

  scope :exported, ->{where("exported = true")}

  
  #def to_param
    #gene_symbol
  #end

  def self.find_by_gene_symbol(id,*args)
    if id.is_a?(String) && !id.match(/\A[a-z0-9]+\z/i)
      return nil
    else
      super id,*args
    end
  end

  def get_chr()
    chr_num = position.match(/^[XY0-9]+/)
    return chr_num
  end

  def self.search_text(search)
    if search
      Gene.exported.where('name LIKE ?', "%#{search}%")
    else
      Gene.exported
    end
  end
  def get_associated_conditions()
    condition_array = Array.new
    # for all seq var
    all_muts = SequenceVariant.where("gene_id = ?",id)
    all_muts.each do |each_mut|
      cond = SequenceVariantMeasurement.where("sequence_variant_id = ?",each_mut.id).first
      cond_id = cond.condition_id
      unless condition_array.include?(cond_id)
        condition_array << cond_id
      end
    end
    # for all gwas rocs data
    all_gwasRocs = SingleNucleotidePolymorphism.where("gene_id = ?",id)
    all_gwasRocs.each do |each_gwasRocs|
      cond_id = each_gwasRocs.condition_id
      unless condition_array.include?(cond_id)
        condition_array << cond_id
      end
    end
    return condition_array
  end
  def get_mutation_stats()
    all_muts = SequenceVariant.where("gene_id = ?",id)
    snp_ctr = 0
    dup_ctr = 0
    invs_ctr = 0
    indel = 0
    other = 0
    # for all sequence variants
    all_muts.each do |each_mut|
      variation = each_mut.variation
      if variation.include?("DEL") or variation.include?("INS")
        indel += 1
      elsif variation.include?("IVS")
        invs_ctr += 1
      elsif variation.include?("DUP")
        dup_ctr += 1
      elsif variation.match(/^[A-Z]{3}[0-9]+[A-Z]{3}/)
        snp_ctr += 1
      else
        other += 1
      end
    end
    # for all gwas rocs data, will all be snps
    all_gwasRocs = SingleNucleotidePolymorphism.where("gene_id = ?",id)
    snp_ctr += all_gwasRocs.length
    res = Hash.new
    res[:snp_ctr] = snp_ctr
    res[:dup_ctr] = dup_ctr
    res[:invs_ctr] = invs_ctr
    res[:indel] = indel
    res[:other] = other
    return res
  end
end

