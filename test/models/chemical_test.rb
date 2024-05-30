require 'test_helper'

class ChemicalTest < ActiveSupport::TestCase
    include ActsAsBiomarkerTest
    include ActsAsAliasableTest

    setup do 
      @chemical = build(:chemical)
      @moldb_methods = [
        :moldb_smiles, :moldb_formula, :moldb_inchi, :moldb_inchikey, 
        :moldb_iupac, :moldb_logp, :moldb_pka, :moldb_average_mass, 
        :moldb_mono_mass, :moldb_alogps_solubility, :moldb_alogps_logp, 
        :moldb_alogps_logs, :moldb_acceptor_count, :moldb_donor_count, 
        :moldb_rotatable_bond_count, :moldb_polar_surface_area, 
        :moldb_refractivity, :moldb_polarizability, :moldb_traditional_iupac,
        :moldb_formal_charge]
    end

    should have_db_column(:name).of_type(:string)
    should have_db_column(:description).of_type(:text)
    should have_db_column(:molecule_type).of_type(:string)
    should have_db_column(:source).of_type(:string)
    should have_db_column(:review_date).of_type(:date)
    should have_db_column(:hmdb).of_type(:string)

    should "have equivalent methods with and without the 'moldb_' prefix" do
      @moldb_methods.each do |method|
        assert_equal @chemical.send(method), @chemical.send(method.to_s.sub(/moldb_/,"")), "method #{method} is not callable without prefix"
      end
    end

    should "not respond to .id with .moldb_id " do
      assert_not_equal @chemical.id, @chemical.moldb_id
    end


    should "respond to moldb methods without the 'moldb_' prefix" do
      @moldb_methods.each do |method|
        assert @chemical.respond_to? method.to_s.sub(/moldb_/,"")
      end
    end

end
