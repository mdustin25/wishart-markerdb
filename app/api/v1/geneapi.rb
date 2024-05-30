module Geneapi
	class GeneRequest < Grape::API
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

			def request_specific_gene(markerdb_id)
				gene = SequenceVariant.joins(:marker_mdbid).find_by("marker_mdbids.mdbid" => markerdb_id)
				if gene.nil?
					return {failed: "markerdb id is not valid"}
				else
					return {
						gene: gene.as_json
					}
				end
			end

		end


		resource :geneapi do

			params do
				optional :name, type: String
				requires :api_key, type: String
				optional :markerdb_id, type: String
				optional :type, type: String         #{ [b]asic or [f]ull or [s]tats}
				optional :format, type: String       # default: JSON; formating already take care of this param
				use :pagination
			end
			# http://localhost:3000/api/v1/geneapi/generequest?api_key=537ff5a9c7b427cd676e9cb288aeff4b&markerdb_id=MDB00000001
			get :generequest  do
				status = check_api_key(params.api_key)
				return {failed: "api_key not valid."} if status.nil?

				if params[:markerdb_id].nil? == false
					return request_specific_gene(params.markerdb_id)
				end


				# return {failed: "query is empty."} if params.query.nil? or params.query.empty?
				# name_ = params.name.gsub("_"," ")
				if params[:name].nil? == false
					if params[:page].nil?
						return {warning: "please indicate page number"}
					end
					genes = SequenceVariant.joins(:marker_mdbid).where("name like '%#{params.name}%'").page(params.page).per(PER_PAGE)
					genes.each do |gene|
						gene.mdbid = gene.marker_mdbid.mdbid
					end
					return {genes: genes,
									page: params.page,
									total_page: genes.count / PER_PAGE}
				end
				
			end

			# forbidden operation
			post :generequest do
				{warning: "You are not allowed to make POST request."}
			end

			delete :generequest do
				{warning: "You are not allowed to make DELETE request."}
			end

			put :generequest do
				{warning: "You are not allowed to make PUT request."}
			end

			patch :generequest do
				{warning: "You are not allowed to make PATCH request."}
			end


		end

	end
end