require 'faker'

FactoryGirl.define do
  
  factory :genre do
    sequence(:name) {|n| "Genre#{n}" }
  end

  factory :director do
    sequence(:name) {|n| "Director#{n}" }
  end

  factory :actor do
    sequence(:name) {|n| "Actor#{n}" }
  end

  factory :trilogy, class: Movie do
    title Faker::Company.name
  end

  factory :movie do
    title Faker::Company.name
  end
  
end




