# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :parent_student_link do
    parent_id 1
    student_id 1
    status "MyString"
  end
end
