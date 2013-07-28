require 'faker'

FactoryGirl.define do
  factory :genre do
    name "Comedy"
  end
end


FactoryGirl.define do
  factory :director do
    name 'Michael Bay'
  end
end

FactoryGirl.define do
  factory :actor do
    name 'Slutty Girl 1'
  end
end

FactoryGirl.define do
  factory :trilogy, class: Movie do
    title Faker::Company.name
  end
end

FactoryGirl.define do
  factory :actors_movies do
    association :actor, factory: :actor
    association :trilogy, factory: :trilogy
  end
end

FactoryGirl.define do
  factory :directors_movies do
    association :director, factory: :director
    association :trilogy, factory: :trilogy
  end
end

FactoryGirl.define do
  factory :genres_movies do
    association :genre, factory: :genre
    association :trilogy, factory: :triology
  end
end



