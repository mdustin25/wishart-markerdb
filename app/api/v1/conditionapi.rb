module Conditionapi
	class ConditionRequest < Grape::API
		include Grape::Extensions::Hashie::Mash::ParamBuilder

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
				condition = Condition.includes(:categories).find_by(:id => condition_id)
				if condition.nil?
					return {failed: "condition id is not valid"}
				end

				measurements = condition.all_measurements
				protein_measurements = condition.protein_measurements
				chemical_measurements = condition.chemical_measurements
				sequence_variants = SequenceVariantMeasurement.includes(:sequence_variant).where("condition_id = ?",condition.id)
				karyotype_indications = KaryotypeIndication.includes(:karyotype).where("condition_id = ?",condition.id)
				references   = condition.references


				return {
					measurements: measurements.as_json,
					protein_measurements: protein_measurements.as_json,
					chemical_measurements: chemical_measurements.as_json,
					sequence_variants: sequence_variants.as_json,
					karyotype_indications: karyotype_indications.as_json,
					references: references.as_json
				}


			end

		end


		resource :conditionapi do

			params do
				requires :query, type: String
				requires :api_key, type: String
				optional :id, type: String
				optional :type, type: String         #{ [b]asic or [f]ull or [s]tats}
				optional :format, type: String       # default: JSON; formating already take care of this param
				use :pagination
			end

			# http://localhost:3000/api/v1/conditionapi/conditionrequest?api_key=537ff5a9c7b427cd676e9cb288aeff4b&query=b
			get :conditionrequest  do
				status = check_api_key(params.api_key)

				if params[:id].nil? == false
					return request_specific_condition(params.id)
				end

				return {failed: "api_key not valid."} if status.nil?
				return {failed: "query is empty."} if params.query.nil? or params.query.empty?

				query = params.query.gsub("_"," ")
				conditions = Condition.where("name like '%#{params.query}%'").page(params.page).per(PER_PAGE)
				return {conditions: conditions,
								page: params.page,
								total_page: conditions.count/PER_PAGE}
			end

			# forbidden operation
			post :conditionrequest do
				{warning: "You are not allowed to make POST request."}
			end

			delete :conditionrequest do
				{warning: "You are not allowed to make DELETE request."}
			end

			put :conditionrequest do
				{warning: "You are not allowed to make PUT request."}
			end

			patch :conditionrequest do
				{warning: "You are not allowed to make PATCH request."}
			end


		end

	end
end