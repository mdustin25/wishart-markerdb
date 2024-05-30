# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :karyotype do
    karyotype "MyString"
    prognosis "MyString"
    num_cases 1
    gender "MyString"
    frequency "MyString"
    description "MyText"
    ideo_description "MyText"
  end
end
