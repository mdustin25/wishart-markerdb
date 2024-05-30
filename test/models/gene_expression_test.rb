require 'test_helper'

class GeneExpressionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
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

