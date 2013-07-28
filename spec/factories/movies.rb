require 'faker'

FactoryGirl.define do
  
  factory :genre do
    name "Genre 1"
  end

  factory :director do
    name 'Director 1'
  end

  factory :actor do
    name 'Actor 1'
  end

  factory :trilogy, class: Movie do
    title Faker::Company.name
  end
end




