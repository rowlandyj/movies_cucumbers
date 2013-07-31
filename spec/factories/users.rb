FactoryGirl.define do
  factory :user do
    name 'Test User'
    email 'example@example.com'
    password 'password'
    password_confirmation 'password'
  end

  factory :collab_user, class: User do
    sequence(:name) {|n| "person#{n}" }
    sequence(:email) {|n| "person#{n}@example.com" }
    password '123456789'
    password_confirmation '123456789'
  end

end
