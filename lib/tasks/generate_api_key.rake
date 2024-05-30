namespace :generate_api_key do

	desc "Task description"
	# rake generate_api_key:generate
	task :generate => [:environment] do
		api = ApiKey.new
		api.email = "test@email.com"
		api.save!
		puts api.access_token

	end

	# def key_generation
	# 	o = [('a'..'z'), ('A'..'Z')].map(&:to_a).flatten
	# 	string = (0...26).map { o[rand(o.length)] }.join
	# 	string
	# end
end