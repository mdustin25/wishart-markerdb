# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  factory :admin_user do
    sequence :email do |n|
      "user#{n}@email.com"
    end
    password "password123"

  end
end
