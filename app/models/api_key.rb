class ApiKey < ActiveRecord::Base

	before_validation :generate_token, on: :create
	before_validation :set_expiration, on: :create
	before_validation :set_token_type, on: :create
	# validates_uniqueness_of :access_token

	def expired?
		DateTime.now >= self.expire_at
	end

	def generate_token

		while true
			token = SecureRandom.hex
			if self.class.exists?(access_token: token) == false
				self.access_token = token
				break
			end
		end

	end

	def set_expiration
		# default one year expiration 
		self.expire_at = DateTime.now + (365)
	end

	def set_token_type
		self.api_type = "ACADEMIA"
	end


end
