# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :uploaded_user do
    batch_id 1
    first_name "MyString"
    last_name "MyString"
    username "MyString"
    email "MyString"
    grade 1
    password "MyString"
    type ""
    message "MyText"
    school_id 1
    created_by_id 1
    approved_by_id 1
    person_id 1
    state "MyString"
  end
end
