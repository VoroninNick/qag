# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :comment do
    user nil
    commentable_type "MyString"
    commentable_id 1
    comment_text "MyText"
    published false
    order_index 1
  end
end
