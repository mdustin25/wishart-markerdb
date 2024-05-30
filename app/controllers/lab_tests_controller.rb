class LabTestsController < ApplicationController

  def index
    @lab_tests = LabTest.page(params[:page])

  end

  def show
    @lab_test = LabTest.
      includes(:test_approvals, :test_uses).
        find(params[:id])
    @fda_kits = @lab_test.fda_kits.
      page(params[:kit_page]).per(20)
  end

end
