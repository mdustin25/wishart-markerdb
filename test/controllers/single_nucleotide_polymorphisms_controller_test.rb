require "test_helper"

class SingleNucleotidePolymorphismsControllerTest < ActionController::TestCase
  def single_nucleotide_polymorphism
    @single_nucleotide_polymorphism ||= single_nucleotide_polymorphisms :one
  end

  def test_index
    get :index
    assert_response :success
    assert_not_nil assigns(:single_nucleotide_polymorphisms)
  end

  def test_new
    get :new
    assert_response :success
  end

  def test_create
    assert_difference("SingleNucleotidePolymorphism.count") do
      post :create, single_nucleotide_polymorphism: { auroc: single_nucleotide_polymorphism.auroc, condition_id: single_nucleotide_polymorphism.condition_id, gene_id: single_nucleotide_polymorphism.gene_id, heritability: single_nucleotide_polymorphism.heritability, logistic_equation: single_nucleotide_polymorphism.logistic_equation, name: single_nucleotide_polymorphism.name, position: single_nucleotide_polymorphism.position, pubmed_id: single_nucleotide_polymorphism.pubmed_id, roc_curve: single_nucleotide_polymorphism.roc_curve }
    end

    assert_redirected_to single_nucleotide_polymorphism_path(assigns(:single_nucleotide_polymorphism))
  end

  def test_show
    get :show, id: single_nucleotide_polymorphism
    assert_response :success
  end

  def test_edit
    get :edit, id: single_nucleotide_polymorphism
    assert_response :success
  end

  def test_update
    put :update, id: single_nucleotide_polymorphism, single_nucleotide_polymorphism: { auroc: single_nucleotide_polymorphism.auroc, condition_id: single_nucleotide_polymorphism.condition_id, gene_id: single_nucleotide_polymorphism.gene_id, heritability: single_nucleotide_polymorphism.heritability, logistic_equation: single_nucleotide_polymorphism.logistic_equation, name: single_nucleotide_polymorphism.name, position: single_nucleotide_polymorphism.position, pubmed_id: single_nucleotide_polymorphism.pubmed_id, roc_curve: single_nucleotide_polymorphism.roc_curve }
    assert_redirected_to single_nucleotide_polymorphism_path(assigns(:single_nucleotide_polymorphism))
  end

  def test_destroy
    assert_difference("SingleNucleotidePolymorphism.count", -1) do
      delete :destroy, id: single_nucleotide_polymorphism
    end

    assert_redirected_to single_nucleotide_polymorphisms_path
  end
end
