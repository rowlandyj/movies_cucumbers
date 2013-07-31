class ApplicationController < ActionController::Base
  protect_from_forgery

  def get_fifty
    # movies = []
    # until movies.length == 52 
    #   random_number = Random.rand(1..Movie.count)
    #   movie = Movie.where(:id => random_number).first
    #   if !movie.nil?
    #     movies << movie unless movies.include? movie
    #   end 
    # end
    # remove_duplicates(movies)
    # movies
    Movie.where(:demo_display => true).sample(52)
  end

  def remove_duplicates(movies)
    movies.delete_if do |movie|
      Rating.where(user_id: current_user.id).pluck(:movie_id).include? movie.id
    end
    movies
  end

  def get_ratings!
    @ratings = current_user.ratings
    @ratings_movie_ids = @ratings.pluck(:movie_id)
    @rating_values = {}
    current_user.ratings.each do |rating|
      @rating_values[rating.movie_id] = rating.rating_value 
    end
  end

  def get_upcoming_movies
   upcoming_movies = HTTParty.get('http://api.rottentomatoes.com/api/public/v1.0/lists/movies/upcoming.json?apikey='+ RT_API_KEY )
   @prepopulated_upcoming_movies = upcoming_movies['movies']
      @prepopulated_upcoming_movies.each do |attr|
        bad_dates = attr['release_dates']['theater'].split('-').map{|d|d.to_i}
        ok_dates = Date.new(bad_dates[0],bad_dates[1],bad_dates[2])
        attr['release_dates']['theater'] = ok_dates.to_formatted_s(:long_ordinal)
      end
  end

end
