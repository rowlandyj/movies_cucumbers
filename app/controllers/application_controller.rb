class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end

  # before_filter :require_login

  # private

  # def require_login
  #   unless current_user
  #     redirect_to new_user_session_path
  #   end
  # end



  def self.rec_engine(rated_movie)

    director = rated_movie.directors.last
    actor = rated_movie.actors.last
    genre = rated_movie.genres.last


    director_movies = Director.find(director.id).movies
    actor_movies = Actor.find(actor.id).movies
    genre_movies = Genre.find(genre.id).movies

    director_movies & genre_movies


    # puts "Director Movies: #{director_movies.length}"
    # puts "Actor Movies: #{actor_movies.length}"
    # puts "Genre Movies: #{genre_movies.length}"
    # director_movies = []
    # Movie.all.each do |movie|
    #   movie.directors.each do |movie_director|
    #     if director == movie_director
    #       director_movies << movie
    #     end
    #   end
    # end



    # actors_movies = []
    # director_movies.each do |movie|
    #   movie.actors.each do |movie_actor|
    #     if actor == movie_actor
    #       actors_movies << movie
    #     end
    #   end
    # end


    # genres_movies = []
    # director_movies.each do |movie|
    #   movie.genres.each do |genre_movie|
    #     if genre == genre_movie
    #       genres_movies << movie
    #     end
    #   end
    # end

    # genres_movies


  end

    

end
