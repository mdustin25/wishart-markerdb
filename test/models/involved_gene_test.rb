require 'test_helper'

class InvolvedGeneTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end


# == Schema Information
#
# Table name: involved_genes
#
#  id                       :integer(4)      not null, primary key
#  gene_id                  :integer(4)
#  involvement              :text
#  involved_with_genes_id   :integer(4)
#  involved_with_genes_type :string(255)
#  created_at               :datetime        not null
#  updated_at               :datetime        not null
#

