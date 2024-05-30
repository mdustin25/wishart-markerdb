# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

# create healthy/normal condition
healthy_conditon = Condition.find_or_create_by(
  :name => "Normal",
  :description => "A healthy individual"
)

healthy_conditon.aliases.find_or_create_by( :name => "Healthy" )
healthy_conditon.aliases.find_or_create_by( :name => "Typical" )
healthy_conditon.aliases.find_or_create_by( :name => "Standard" )

puts 'DEFAULT USERS'
user = User.where(:email => ENV['ADMIN_EMAIL'].dup).first_or_create(
  #:name => ENV['ADMIN_NAME'].dup,
  :email => ENV['ADMIN_EMAIL'].dup,
  :password => ENV['ADMIN_PASSWORD'].dup,
  :password_confirmation => ENV['ADMIN_PASSWORD'].dup,
  :super => true
)

puts 'DEFAULT ADMIN USERS'
user = AdminUser.where(:email => ENV['ADMIN_EMAIL'].dup).first_or_create(
  #:name => ENV['ADMIN_NAME'].dup,
  :email => ENV['ADMIN_EMAIL'].dup,
  :password => ENV['ADMIN_PASSWORD'].dup,
  :password_confirmation => ENV['ADMIN_PASSWORD'].dup
)
