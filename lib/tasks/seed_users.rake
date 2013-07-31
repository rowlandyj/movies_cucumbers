include RecommendationSystem

desc "Delete all users and seed the DB with 2 users" 
task :seed_users => :environment do 
  User.delete_all
  u1 = User.create(email: "navidm@cucumbers.com", password: "password", password_confirmation: "password")
  u2 = User.create(email: "rowland@cucumbers.com", password: "password", password_confirmation: "password")
  
  u1.ratings << Rating.create(movie_id: 771, rating_value: 5)
  update_recommendations(771, 5, u1.id)

  u1.ratings << Rating.create(movie_id: 883, rating_value: 5)
  update_recommendations(883, 5, u1.id)

  u1.ratings << Rating.create(movie_id: 2646, rating_value: 5)
  update_recommendations(2646, 5, u1.id)

end 

