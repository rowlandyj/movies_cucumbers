class Movie < ActiveRecord::Base

  attr_accessible :title, :rt_id, :tmdb_id, :director_id, :release_year, :critic_consensus, :rt_score, :poster_url, :trailer_url, :mpaa_rating, :run_time
  has_many :ratings
  has_many :actors_movies
  has_many :genres_movies
  has_many :ratings
  has_many :directors

  def self.seed
    movie = RottenMovie.find(id: 9)

    unless movie.empty?
      
      if movie.respond_to?(:links) && movie.links.respond_to?(:clips)
        clips_url = movie.links.clips
      end

      clips = HTTParty.get(clips_url + "?apikey=" + RT_API_KEY)
      unless clips['clips'].empty?
        trailer_url = clips['clips'].first['links']['alternate']
      else
        trailer_url = 'http://www.apple.com/trailers'
      end

      if movie.respond_to?(:posters) && movie.posters.respond_to?(:detailed)
        poster_url = movie.posters.detailed
      end

      Movie.find_or_create_by_rt_id( title: movie.title,
                              rt_id:  movie.id,
                              release_year: movie.year,
                              critic_consensus: movie.critics_consensus,
                              rt_score: movie.ratings.critics_score,
                              poster_url: poster_url,
                              trailer_url: trailer_url,
                              mpaa_rating: movie.mpaa_rating,
                              run_time: movie.runtime
                              )


    end

  end


end