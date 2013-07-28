require 'faker'

FactoryGirl.define do
  factory :trilogy, class: Movie do
    title Faker::Company.name
    genres ['Comedy']
    directors ['Michael Bay']
    actors ['slutty girl 1']
  end
end


genre_arr = ['Comedy','Action', 'Drama', 'Horror', 'Animation']
director_arr = %w(dir1, dir2, dir3, dir4)
actor_arr = %w(actor1,actor2,actor3,actor4,actor5,actor6)

FactoryGirl.define do
  factory :movie do
    title Faker::Company.name
    genres genre_arr.sample
    directors director_arr.sample
    actors actor_arr.sample
  end
end

