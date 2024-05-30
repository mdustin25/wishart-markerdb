class ErrorController < ApplicationController


	def not_found
		# render :status => 404
		respond_to do |format|
			format.html { render status: 404 }
			format.all  { render status: 404 }
		end
	end

	def unacceptable
		respond_to do |format|
			format.html { render status: 422 }
			format.all  { render status: 422 }
		end
	end

	def internal_error
		respond_to do |format|
			format.html { render status: 500 }
			format.all  { render status: 500 }
		end
	end
end
