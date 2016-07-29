# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :teacher_credit do
    school_id 1
    teacher_id 1
    teacher_name "MyString"
    district_guid "MyString"
    amount "9.99"
    credit_source "MyString"
  end
end
