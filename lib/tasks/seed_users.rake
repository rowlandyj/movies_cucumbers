<<<<<<< HEAD
=======
require_relative '../recommendation_system.rb'
>>>>>>> added seed_user rake task
include RecommendationSystem

desc "Delete all users and seed the DB with 2 users" 
task :seed_users => :environment do 
  User.delete_all
  u1 = User.create(email: "navidm@cucumbers.com", password: "password", password_confirmation: "password")
  u2 = User.create(email: "rowland@cucumbers.com", password: "password", password_confirmation: "password")
  
  u1.ratings << Rating.create(movie_id: 771, rating_value: 5)
  update_recommendations(771, 5, u1)

  u1.ratings << Rating.create(movie_id: 883, rating_value: 5)
  update_recommendations(883, 5, u1)

  u1.ratings << Rating.create(movie_id: 2646, rating_value: 5)
  update_recommendations(2646, 5, u1)

  u1.ratings << Rating.create(movie_id: 554, rating_value: 3)
  update_recommendations(554, 3, u1)

  u1.ratings << Rating.create(movie_id: 11561, rating_value: 3)
  update_recommendations(11561, 3, u1)

  u1.ratings << Rating.create(movie_id: 6250, rating_value: 1)
  update_recommendations(6250, 1, u1)

  u2.ratings << Rating.create(movie_id: 771, rating_value: 4)
  update_recommendations(771, 4, u2)

  u2.ratings << Rating.create(movie_id: 883, rating_value: 5)
  update_recommendations(883, 5, u2)

  u2.ratings << Rating.create(movie_id: 2646, rating_value: 5)
  update_recommendations(2646, 5, u2)

  u2.ratings << Rating.create(movie_id: 1588, rating_value: 5)
  update_recommendations(1588, 5, u2)

  u2.ratings << Rating.create(movie_id: 2803, rating_value: 5)
  update_recommendations(2803, 5, u2)

  u2.ratings << Rating.create(movie_id: 180, rating_value: 3)
  update_recommendations(180, 3, u2)

  u2.ratings << Rating.create(movie_id: 6849, rating_value: 2)
  update_recommendations(6849, 2, u2)

  u2.ratings << Rating.create(movie_id: 7979, rating_value: 4)
  update_recommendations(7979, 4, u2)

end 

