# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    name 'Test User'
    email 'example@example.com'
    password 'changeme'
    password_confirmation 'changeme'
    # required if the Devise Confirmable module is used
    # confirmed_at Time.now
  end

  factory :collab_user, class: User do
    sequence(:name) {|n| "person#{n}" }
    sequence(:email) {|n| "person#{n}@example.com" }
    password '123456789'
    password_confirmation '123456789'
  end

end
