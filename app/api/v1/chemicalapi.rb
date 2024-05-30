module Chemicalapi
	class ChemicalRequest < Grape::API
		include Grape::Extensions::Hashie::Mash::ParamBuilder

		PER_PAGE = 10

		version 'v1', using: :path  # this v1 will encode to /api/v1/...
		content_type :json, 'application/json'
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

			def request_specific_chemical(markerdb_id)
				chemical = Chemical.joins(:marker_mdbid).find_by(:mdbid => markerdb_id)
				if chemical.nil?
					return {failed: "markerdb id is not valid"}
				else
					return {
						compound: chemical.as_json,
						abnormal_concentration: chemical.abnormal_levels.as_json,
						normal_concentration: chemical.normal_levels.as_json
					}
				end
			end

			def request_specific_chemical_by_structure(structure)

			end

		end


		resource :chemicalapi do

			params do
				optional :name, type: String
				requires :api_key, type: String
				optional :markerdb_id, type: String
				optional :type, type: String         #{ [b]asic or [f]ull or [s]tats}
				optional :format, type: String       # default: JSON; formating already take care of this param
				optional :structure, type: String		 # could be inchi, inchikey or smiles
				use :pagination
			end
			# http://localhost:3000/api/v1/chemicalapi/chemicalrequest?api_key=537ff5a9c7b427cd676e9cb288aeff4b&markerdb_id=MDB00000001
			get :chemicalrequest  do
				status = check_api_key(params.api_key)
				return {failed: "api_key not valid."} if status.nil?

				if params[:markerdb_id].nil? == false
					return request_specific_chemical(params.markerdb_id)
				end

				if params[:structure].nil? == false
					return request_specific_chemical_by_structure(params.structure)
				end

				# return {failed: "query is empty."} if params.query.nil? or params.query.empty?
				# name_ = params.name.gsub("_"," ")
				if params[:name].nil? == false
					if params[:page].nil?
						return {warning: "please indicate page number"}
					end
					chemicals = Chemical.joins(:marker_mdbid).where("name like '%#{params.name}%'").page(params.page).per(PER_PAGE)
					return {chemicals: chemicals,
									page: params.page,
									total_page: chemicals.count/PER_PAGE}
				end
				
			end

			# forbidden operation
			post :chemicalrequest do
				{warning: "You are not allowed to make POST request."}
			end

			delete :chemicalrequest do
				{warning: "You are not allowed to make DELETE request."}
			end

			put :chemicalrequest do
				{warning: "You are not allowed to make PUT request."}
			end

			patch :chemicalrequest do
				{warning: "You are not allowed to make PATCH request."}
			end


		end

	end
end