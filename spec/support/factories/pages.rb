# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :page do
    title "MyString"
    slug "MyString"
    path "MyString"
    meta_keywords "MyString"
    meta_description "MyString"
    link_url "MyString"
    show_in_menu false
    title_in_menu "MyString"
    skip_to_first_child false
    draft false
    tree "MyString"
  end
end
