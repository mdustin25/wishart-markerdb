set :stage, :production
set :branch, "master"

role :app, "markerdb@162.243.13.74"
role :web, "markerdb@162.243.13.74"
role :db,  "markerdb@162.243.13.74"
