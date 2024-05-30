# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  
  factory :user do
    sequence :email do |n|
      "user#{n}@email.com"
    end
    password "password123"      
    sequence(:super){|n|false}

    factory :admin do 
      sequence(:super){|n|true}
    end

  end
end
