require "test_helper"

class SingleNucleotidePolymorphismTest < ActiveSupport::TestCase
  def single_nucleotide_polymorphism
    @single_nucleotide_polymorphism ||= SingleNucleotidePolymorphism.new
  end

  def test_valid
    assert single_nucleotide_polymorphism.valid?
  end
end
