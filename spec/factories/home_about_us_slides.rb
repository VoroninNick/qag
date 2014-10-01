# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :home_about_us_slide do
    title "MyString"
    short_description "MyText"
    published false
    order_index 1
  end
end
