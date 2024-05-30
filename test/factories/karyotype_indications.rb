# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :karyotype_indication do
    condition_id 1
    indication_type_id 1
    biomarker_category_id 1
    indication_modifier "MyString"
  end
end
