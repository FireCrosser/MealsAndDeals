FactoryGirl.define do

  factory :role do |r|
    r.name { Faker::Name.unique.name }
  end

  factory :user do |u|
    u.email { Faker::Internet.email }
    u.name { Faker::Name.first_name }
    u.password "deathstar"
    u.password_confirmation "deathstar"
  end
end

