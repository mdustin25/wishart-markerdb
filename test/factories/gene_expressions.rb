# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :gene_expression do
    expression_profile_id 1
    gene_id 1
    relative_expression "MyString"
    probe_id "MyString"
    gene_symbol "MyString"
    profile_rank 1.5
    profile_importance 1.5
  end
end
