module RecommendationSystem

  REC_LIMIT = [5, 10, 25, 45, 50]
  PEARSON_CORR_CONTROL_VALUE = 100000 #arbritrary large number far from 1, used in pearson correlation

  # Appending/Updating movie recommendation list.  
  def update_recommendations(movie_id, rating_value, current_user)
    closest_user_id = find_closest_user_id(current_user)
    recs_from_closest_user = []

    unless closest_user_id.nil?
      movies_to_rec = get_movies_from_closest_user(current_user, closest_user_id)
      recs_from_closest_user = create_recommendation_list(movies_to_rec, current_user.id, rating_value)
    end

    newly_rated_movie_cluster = unit_cluster(Movie.find(movie_id), rating_value, current_user, recs_from_closest_user)

    newly_rated_movie_cluster.each do |new_movie|
      current_user.recommendations << Recommendation.create(movie_id: new_movie.id, user_id: current_user.id)
    end

    current_user.recommendations = current_user.recommendations.sample(50)
  end 


  # Iterating through all users to find the closest user for a target user (uses pearson_corr)
  def find_closest_user_id(target_user)
    temp_user = User.includes(:ratings => :movie)

    closest_user = [temp_user.first.id, pearson_corr(target_user.ratings, temp_user.first.ratings)]

    temp_user.each do |user|      
      if user.id != target_user.id
        curr_pearson_corr = pearson_corr(target_user.ratings, user.ratings) 

        if (1-curr_pearson_corr).abs < (1-closest_user.last).abs
          closest_user = [user.id, curr_pearson_corr]
        end
      end
    end
    closest_user[1] == PEARSON_CORR_CONTROL_VALUE ? nil : closest_user[0]
  end

  # Finds the 'distance' between two users...literally the pearson correlation coefficient
  def pearson_corr(target_user_ratings, other_user_ratings)
    target_rating_hash = Hash[target_user_ratings.pluck(:movie_id).zip(target_user_ratings.pluck(:rating_value))]
    other_rating_hash = Hash[other_user_ratings.pluck(:movie_id).zip(other_user_ratings.pluck(:rating_value))]

    shared_movie_ids = target_rating_hash.keys.reject{ |k| other_rating_hash[k].nil? }


    return PEARSON_CORR_CONTROL_VALUE if shared_movie_ids.empty? #arbitrary big number far from 1 

    number_of_shared_movie_ids = shared_movie_ids.length

    target_user_rating_sum = shared_movie_ids.inject(0) { |sum, movie| sum += target_rating_hash[movie] }
    

    target_user_rating_avg = target_user_rating_sum.to_f/number_of_shared_movie_ids


    other_user_rating_sum = shared_movie_ids.inject(0) { |sum, movie| sum += other_rating_hash[movie] }

    other_user_rating_avg = other_user_rating_sum.to_f/number_of_shared_movie_ids

    deviation = shared_movie_ids.inject(0) do |sum, movie_id|
      target = target_rating_hash[movie_id] - target_user_rating_avg
      other = other_rating_hash[movie_id] - other_user_rating_avg
      sum + (target * other)
    end


    square_target = shared_movie_ids.inject(0) do |sum, movie_id|
      sum + ((target_rating_hash[movie_id] - target_user_rating_avg)**2)
    end

    square_other = shared_movie_ids.inject(0) do |sum, movie_id|
      sum + ((other_rating_hash[movie_id] - other_user_rating_avg)**2)
    end

    denominator = Math.sqrt(square_target * square_other)

    return deviation.to_f / denominator.to_f
  end

  # Returns movies that the closest user has rated 4 or 5 stars that target user has not rated
  def get_movies_from_closest_user(target, closest_id)
    closest = User.where(:id => closest_id).includes(:ratings => :movie).first
    movies_of_interest = closest.ratings.map(&:movie_id) - target.ratings.map(&:movie_id)
    movies_of_interest = Movie.includes(:ratings => :user).where("users.id" => closest_id).where("ratings.rating_value > 3").map(&:id)
  end

# Adds up to 80% of the movies found by get_movies_from_closest_user method to target user's recommendation list
  def create_recommendation_list(movie_ids, target_id, rating_value)
    collaborative_limit = REC_LIMIT[rating_value - 1]*(0.1) #80% of REC_LIMIT value

    if movie_ids.length > collaborative_limit
      movie_ids = movie_ids[0..collaborative_limit]
    end

    recommendations = movie_ids.map { |movie_id| Recommendation.create(movie_id: movie_id, user_id: target_id) }
  end

# Returns movies that are similar to the rated movie (our version of k-means clustering)
  def unit_cluster(rated_movie, rating, current_user, total_recs=[])
  
  # Gets all directors, actors, and genres from the rated movie
    directors = rated_movie.directors
    actors = rated_movie.actors
    genres = rated_movie.genres

  # Gets all movies related to director, actor, genre (based off of target movie)
    director_rec_list(directors,directors_movies=[])
    actor_rec_list(actors,actors_movies=[])
    genre_rec_list(genres,genres_movies=[])

  # Gets intersection of movie lists with various combinations (eg: all movies with same director, same actor, same genre)
    actor_director_genre_recs = directors_movies & actors_movies & genres_movies
    actor_director_recs = directors_movies & actors_movies
    director_genre_recs = directors_movies & genres_movies
    actor_genre_recs = genres_movies & actors_movies

    populate_rec_list(actor_director_genre_recs, total_recs, rating, rated_movie, current_user)
    populate_rec_list(actor_director_recs, total_recs, rating, rated_movie, current_user)
    populate_rec_list(director_genre_recs, total_recs, rating, rated_movie, current_user)
    populate_rec_list(actor_genre_recs, total_recs, rating, rated_movie, current_user)
    populate_rec_list(directors_movies, total_recs, rating, rated_movie, current_user)
    populate_rec_list(actors_movies, total_recs, rating, rated_movie, current_user)
    populate_rec_list(genres_movies, total_recs, rating, rated_movie, current_user)

    total_recs
  end

# Gets all movies that were directed by the target director
  def director_rec_list(directors,directors_movies)
    directors.each do |director|
      directors_movies << Director.where(:id => director.id).includes(:movies).first.movies
    end
    directors_movies.flatten!
  end

# Gets all movies that were acted by the target actor
  def actor_rec_list(actors,actors_movies)
    actors.each do |actor|
      actors_movies << Actor.where(:id => actor.id).includes(:movies).first.movies
    end
    actors_movies.flatten!
  end

# Gets all movies in the target genre
  def genre_rec_list(genres,genres_movies)
    genres.each do |genre|
      genres_movies << Genre.where(:id => genre.id).includes(:movies).first.movies
    end
    genres_movies.flatten!
  end

# Adds movies from clustering to recommendation list (there is a limit to the amount of movies added based on rating value of the target movie)
  def populate_rec_list(chosen_list, total_recs, rating, rated_movie, current_user)
    if total_recs.length < REC_LIMIT[rating-1]
      chosen_list.each do |movie|
        if total_recs.length < REC_LIMIT[rating-1] && movie.id != rated_movie.id
          total_recs << movie unless current_user.ratings.map(&:movie_id).include? movie.id
        end
      end
    end
  end

end
