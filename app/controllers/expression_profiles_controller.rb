class ExpressionProfilesController < ApplicationController
  def index
    @profiles = ExpressionProfile.all
  end

  def show
    @profile      = ExpressionProfile.find(params[:id])
    @profile_sets = @profile.profile_sets.sort
  end
end
