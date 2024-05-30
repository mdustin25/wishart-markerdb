module Proteinapi
	class ProteinRequest < Grape::API
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

			def request_specific_protein(markerdb_id)
				protein =  Protein.joins(:marker_mdbid).find_by("marker_mdbids.mdbid" => markerdb_id)
				if protein.nil?
					return {failed: "markerdb id is not valid"}
				else
					prot_sequence_obj = PolypeptideSequence.where("type = \"PolypeptideSequence\" and sequenceable_type = \"Protein\" and sequenceable_id = ?",protein.id).first
					
					return {
						protein: protein.as_json,
						sequence: prot_sequence_obj.as_json,
						abnormal_concentration: protein.abnormal_levels.as_json,
						normal_concentration: protein.normal_levels.as_json
					}
				end
			end
		end


		resource :proteinapi do

			params do
				optional :name, type: String
				requires :api_key, type: String
				optional :markerdb_id, type: String
				optional :type, type: String         #{ [b]asic or [f]ull or [s]tats}
				optional :format, type: String       # default: JSON; formating already take care of this param
				use :pagination
			end
			# http://localhost:3000/api/v1/proteinapi/proteinrequest?api_key=537ff5a9c7b427cd676e9cb288aeff4b&markerdb_id=MDB00000001
			get :proteinrequest  do
				status = check_api_key(params.api_key)
				return {failed: "api_key not valid."} if status.nil?

				if params[:markerdb_id].nil? == false
					return request_specific_protein(params.markerdb_id)
				end

				# return {failed: "query is empty."} if params.query.nil? or params.query.empty?
				# name_ = params.name.gsub("_"," ")
				if params[:name].nil? == false
					if params[:page].nil?
						return {warning: "please indicate page number"}
					end
					proteins = Protein.joins(:marker_mdbid).where("name like '%#{params.name}%'").page(params.page).per(PER_PAGE)
					proteins.each do |protein|
						protein.mdbid = protein.marker_mdbid.mdbid
					end
					return {proteins: proteins,
									page: params.page,
									total_page: proteins.count/PER_PAGE}
				end
				
			end

			# forbidden operation
			post :proteinrequest do
				{warning: "You are not allowed to make POST request."}
			end

			delete :proteinrequest do
				{warning: "You are not allowed to make DELETE request."}
			end

			put :proteinrequest do
				{warning: "You are not allowed to make PUT request."}
			end

			patch :proteinrequest do
				{warning: "You are not allowed to make PATCH request."}
			end


		end

	end
end