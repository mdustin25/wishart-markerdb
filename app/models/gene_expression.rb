class GeneExpression #< ActiveRecord::Base
  extend ActiveModel::Naming

  #belongs_to :expression_profile
  #belongs_to :gene

  attr_accessor :gene_symbol, :probe_id, :rank_freq, 
    :importance
  attr_writer :control_level, :disease_level

  def control_level
    @control_level.downcase
  end

  def disease_level
    @disease_level.downcase
  end

end

# == Schema Information
#
# Table name: gene_expressions
#
#  id                    :integer(4)      not null, primary key
#  expression_profile_id :integer(4)
#  gene_id               :integer(4)
#  relative_expression   :string(255)
#  probe_id              :string(255)
#  gene_symbol           :string(255)
#  profile_rank          :float
#  profile_importance    :float
#  created_at            :datetime        not null
#  updated_at            :datetime        not null
#

