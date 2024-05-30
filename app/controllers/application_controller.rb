class ApplicationController < ActionController::Base
  protect_from_forgery
  
  helper Unearth::ExtractableHelper  
  helper Unearth::FilterableHelper
  helper Wishart::Engine.helpers
  helper Moldbi::StructureResourcesHelper
  helper TmicBanner::Engine.helpers

  helper :all

end

