require 'faker'

FactoryGirl.define do
  factory :movie do
    title Faker::Company.name
    genres ['Comedy']
    directors ['Michael Bay']
    actors ['slutty girl 1']
  end
end
