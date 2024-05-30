# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :expression_profile do
    condition_id 1
    series_id "MyString"
    title "MyString"
    release_date "2012-04-24"
    platform_id "MyString"
    platform_name "MyString"
    summary "MyText"
    overall_design "MyText"
    probe_id_type "MyString"
    sample_source "MyString"
    group_1_name "MyString"
    group_1_sample_size 1
    group_2_name "MyString"
    group_2_sample_size 1
    group_2_description "MyString"
  end
end
