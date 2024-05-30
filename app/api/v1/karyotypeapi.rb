module Karyotypeapi
	class KaryotypeRequest < Grape::API
		include Grape::Extensions::Hashie::Mash::ParamBuilder

		PER_PAGE = 10

		version 'v1', using: :path  # this v1 will encode to /api/v1/...
		content_type :json, 'application/json'
		default_format :json
		rescue_from :all 


		helpers do 
			params :pagination do
				optional :page, type: Integer
				optional :per_page, type: Integer
			end

			def check_api_key(api_key)
				api_key = ApiKey.find_by(access_token: api_key)
				api_key
			end

			def request_specific_kary(markerdb_id)
				karyotype = Karyotype.joins(:marker_mdbid).find_by("marker_mdbids.mdbid" => markerdb_id)

				if karyotype.nil?
					return {failed: "markerdb id is not valid"}
				else
					karyotype.mdbid = karyotype.marker_mdbid.mdbid
					return {
						karyotype: karyotype.as_json
					}
				end
			end

		end


		resource :karyotypeapi do

			params do
				requires :api_key, type: String
				optional :markerdb_id, type: String
				optional :type, type: String         #{ [b]asic or [f]ull or [s]tats}
				optional :format, type: String       # default: JSON; formating already take care of this param
				use :pagination
			end
			# http://localhost:3000/api/v1/karyotypeapi/karyotyperequest?api_key=537ff5a9c7b427cd676e9cb288aeff4b&markerdb_id=MDB00000001
			get :karyotyperequest  do
				status = check_api_key(params.api_key)
				return {failed: "api_key not valid."} if status.nil?

				if params[:markerdb_id].nil? == false
					return request_specific_kary(params.markerdb_id)
				else
					return {warning: "missing markerdb id."}
				end
				
			end

			# forbidden operation
			post :karyotyperequest do
				{warning: "You are not allowed to make POST request."}
			end

			delete :karyotyperequest do
				{warning: "You are not allowed to make DELETE request."}
			end

			put :karyotyperequest do
				{warning: "You are not allowed to make PUT request."}
			end

			patch :karyotyperequest do
				{warning: "You are not allowed to make PATCH request."}
			end


		end

	end
end