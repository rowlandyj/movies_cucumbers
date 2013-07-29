class UpdateRecsWorker
  include Sidekiq::Worker

  REC_LIMIT = [5, 10, 25, 45, 50]


  def pearson_corr(target_user_ratings, other_user_ratings)
    target_rating_hash = Hash[target_user_ratings.pluck(:movie_id).zip(target_user_ratings.pluck(:rating_value))]
    other_rating_hash = Hash[other_user_ratings.pluck(:movie_id).zip(other_user_ratings.pluck(:rating_value))]

    shared_movie_ids = target_rating_hash.keys.reject{ |k| other_rating_hash[k].nil? }    
    return 0 if shared_movie_ids.empty?

    number_of_shared_movie_ids = shared_movie_ids.length

    target_user_rating_sum = target_user_ratings.inject(0) { |sum, rating| sum += rating.rating_value }
    target_user_rating_avg = target_user_rating_sum/number_of_shared_movie_ids

    other_user_rating_sum = other_user_ratings.inject(0) { |sum, rating| sum += rating.rating_value }
    other_user_rating_avg = other_user_rating_sum/number_of_shared_movie_ids

    deviation = shared_movie_ids.inject(0) do |sum, movie_id|
      target = target_rating_hash[movie_id] - target_user_rating_avg
      other = other_rating_hash[movie_id] - other_user_rating_avg
      sum + (target * other)
    end

    square_target = shared_movie_ids.inject(0) do |sum, movie_id|
      sum + ((target_rating_hash[movie_id] + target_user_rating_avg)**2)
    end

    square_other = shared_movie_ids.inject(0) do |sum, movie_id|
      sum + ((other_rating_hash[movie_id] + other_user_rating_avg)**2)
    end

    denominator = Math.sqrt(square_target * square_other)

    return deviation / denominator
  end

  def find_closest_user(target_user)
    closest_user = [User.first.id, pearson_corr(target_user, User.first)]
    
    User.all.each do |user|      
      if user.id != target_user.id
        curr_pearson_corr = pearson_corr(target_user,user) 
        
        if abs(1-curr_pearson_corr) < abs(1-closest_user.last)
          closest_user = [user.id, curr_pearson_corr]
        end
      end
      return closest_user
    end
  end

  def get_rating_lists(target, closest)
    rated_recs = closest.ratings.pluck(:movie_id) - target.ratings.select{|r| r.rating_value > 3}
    rated_recs.map {|rating| rating.movie_id}
  end


  def unit_cluster(rated_movie, rating, current_user)

    directors = rated_movie.directors
    actors = rated_movie.actors
    genres = rated_movie.genres


    director_rec_list(directors,directors_movies=[])
    actor_rec_list(actors,actors_movies=[])
    genre_rec_list(genres,genres_movies=[])

    actor_director_genre_recs = directors_movies & actors_movies & genres_movies
    actor_director_recs = directors_movies & actors_movies
    director_genre_recs = directors_movies & genres_movies
    actor_genre_recs = genres_movies & actors_movies

    total_recs = []

    populate_rec_list(actor_director_genre_recs, total_recs, rating, rated_movie, current_user)
    populate_rec_list(actor_director_recs, total_recs, rating, rated_movie, current_user)
    populate_rec_list(director_genre_recs, total_recs, rating, rated_movie, current_user)
    populate_rec_list(actor_genre_recs, total_recs, rating, rated_movie, current_user)
    populate_rec_list(directors_movies, total_recs, rating, rated_movie, current_user)
    populate_rec_list(actors_movies, total_recs, rating, rated_movie, current_user)
    populate_rec_list(genres_movies, total_recs, rating, rated_movie, current_user)

    total_recs
  end


  def director_rec_list(directors,directors_movies)
    directors.each do |director|
      directors_movies << Director.find(director.id).movies
    end
    directors_movies.flatten!
  end

  def actor_rec_list(actors,actors_movies)
    actors.each do |actor|
      actors_movies << Actor.find(actor.id).movies
    end
    actors_movies.flatten!
  end

  def genre_rec_list(genres,genres_movies)
    genres.each do |genre|
      genres_movies << Genre.find(genre.id).movies
    end
    genres_movies.flatten!
  end

  def populate_rec_list(chosen_list, total_recs, rating, rated_movie, current_user)
    if total_recs.length < REC_LIMIT[rating-1]
      chosen_list.each do |movie|
        if total_recs.length < REC_LIMIT[rating-1] && movie.id != rated_movie.id
          total_recs << movie unless current_user.ratings.pluck(:movie_id).include? movie.id
        end
      end
    end
  end

  def update_recommendations(movie_id, rating_value, current_user)
    newly_rated_movie_cluster = unit_cluster(Movie.find(movie_id), rating_value, current_user)
    puts "Cluster Length: #{newly_rated_movie_cluster.length}"
    newly_rated_movie_cluster.each do |new_movie|
      current_user.recommendations << Recommendation.create(movie_id: new_movie.id, user_id: current_user.id)
    end
    puts "Current User Recs: #{current_user.recommendations.length}"
    current_user.recommendations = current_user.recommendations.sample(50)
    puts "Current User Recs Post Sampe: #{current_user.recommendations.length}"
  end 


  def perform(movie_id, rating_value, id)
    current_user = User.find(id)
    update_recommendations(movie_id, rating_value, current_user)
  end

end
