class UpdateRecsWorker
  include Sidekiq::Worker

  REC_LIMIT = [5, 10, 25, 45, 50]

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