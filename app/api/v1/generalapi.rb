module Generalapi
	class GeneralRequest < Grape::API
		include Grape::Extensions::Hashie::Mash::ParamBuilder

		Category = ["Predictive","Diagnostic", "Prognostic","Exposure"]
		PER_PAGE = 10

		version 'v1', using: :path  # this v1 will encode to /api/v1/...
		content_type :json, 'application/json'
		# content_type :xml, 'application/xml'
		default_format :json
		rescue_from :all            # StandardError exceptions and return them in the API format.



		helpers do 
			params :pagination do
				optional :page, type: Integer
				optional :per_page, type: Integer
			end

			def check_api_key(api_key)
				api_key = ApiKey.find_by(access_token: api_key)
				api_key
			end

			def request_specific_condition(condition_id)
				
			end



		end


		resource :generalapi do

			params do
				requires :api_key, type: String
				requires :category, type: String
				requires :biomarker_type, type: String
				optional :id, type: String
				optional :type, type: String         #{ [b]asic or [f]ull or [s]tats}
				optional :format, type: String       # default: JSON; formating already take care of this param
				use :pagination
			end

			# http://localhost:3000/api/v1/generalapi/generalrequest?api_key=537ff5a9c7b427cd676e9cb288aeff4b&query=b
			get :generalrequest  do
				status = check_api_key(params.api_key)

				if params[:id].nil? == false
					return request_specific_condition(params.id)
				end

				return {failed: "api_key not valid."} if status.nil?

				if params[:page].nil?
					return {warning: "please indicate page number"}
				end

				category_id = Category.find_index(params.category) + 1

				biomarkers = BiomarkerCategoryMembership.where(:biomarker_category_id => category_id).select("distinct biomarker_id, biomarker_type").page(params.page).per(PER_PAGE)
				biomarker_hash = Hash.new
				biomarkers.each do |marker|
				  key = {
				         "biomarker_id" => marker.biomarker_id,
				         "biomarker_type" => marker.biomarker_type
				        }

				  biomarker_hash[key] = []

				  partial_biomarker = BiomarkerCategoryMembership.where(:biomarker_category_id => category_id, :biomarker_id => marker.biomarker_id, :biomarker_type => params.biomarker_type)      

				  partial_biomarker.each do |partials|
				    biomarker_hash[key] << {
				                            "biomarker_name" => partials.biomarker_name,
				                            "mdbid" => partials.mdbid,
				                            "condition_id" => partials.condition_id,
				                            "condition_name"=> partials.condition_name
				                            }

				  end
				end

				return {biomarkers: biomarker_hash.as_json,
								page: params.page,
								total_page: biomarker_hash.count / PER_PAGE}
			end

			# forbidden operation
			post :generalrequest do
				{warning: "You are not allowed to make POST request."}
			end

			delete :generalrequest do
				{warning: "You are not allowed to make DELETE request."}
			end

			put :generalrequest do
				{warning: "You are not allowed to make PUT request."}
			end

			patch :generalrequest do
				{warning: "You are not allowed to make PATCH request."}
			end


		end

	end
end