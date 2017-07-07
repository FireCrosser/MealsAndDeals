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

  factory :course_type do |ct|
    ct.name 'second'
  end

  factory :course do |c|
    c.name 'Varenyky'
    c.price 12.5
    course_type
  end
end

