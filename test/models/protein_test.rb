require 'test_helper'

class ProteinTest < ActiveSupport::TestCase
    include ActsAsBiomarkerTest
    include ActsAsAliasableTest

    should have_db_column(:name).of_type(:string)
    should have_db_column(:description).of_type(:text)
    should have_db_column(:protein_type).of_type(:string)
    should have_db_column(:source).of_type(:string)
    should have_db_column(:review_date).of_type(:date)

    # structure files (these might end up being flat files
    should have_db_column(:pdb_file).of_type(:text)
    should have_db_column(:sdf_file).of_type(:text)
    should have_db_column(:mol_file).of_type(:text)
end

# == Schema Information
#
# Table name: proteins
#
#  id               :integer(4)      not null, primary key
#  name             :string(255)
#  description      :text
#  gene_name        :string(255)
#  gene_position    :string(255)
#  protein_sequence :text
#  gene_sequence    :text
#  pdb_file         :text
#  sdf_file         :text
#  mol_file         :text
#  created_at       :datetime
#  updated_at       :datetime
#  source           :string(255)
#  protein_type     :string(255)
#  review_date      :date
#

