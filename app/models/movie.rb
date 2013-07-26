class Movie < ActiveRecord::Base

  attr_accessible :title, :rt_id, :tmdb_id, :director_id, :release_year, :critic_consensus, :rt_score, :poster_url, :trailer_url, :mpaa_rating, :run_time
  has_many :ratings
  has_many :user, through: :ratings

  has_many :actors_movies
  has_many :actors, through: :actors_movies

  has_many :genres_movies
  has_many :genres, through: :genres_movies

  belongs_to :director

  def self.seed(min_id, max_id)

    (min_id).upto(max_id) do |i|
      movie = RottenMovie.find(id: i)
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

        movie_in_db = Movie.find_or_create_by_rt_id( title: movie.title,
          rt_id:  movie.id,
          release_year: movie.year,
          critic_consensus: movie.critics_consensus,
          rt_score: movie.ratings.critics_score,
          poster_url: poster_url,
          trailer_url: trailer_url,
          mpaa_rating: movie.mpaa_rating,
          run_time: movie.runtime
          )


        director = Director.find_or_create_by_name(name: movie.abridged_directors.first.name)
        director.movies << movie_in_db

        3.times do |index|
          unless movie.abridged_cast[index].nil?
            actor = Actor.find_or_create_by_name(name: movie.abridged_cast[index].name) 
            movie_in_db.actors << actor
          end
        end

        movie.genres.each do |genre|
          unless genre.nil?
            genre_in_db = Genre.find_or_create_by_name(name: genre)
            movie_in_db.genres << genre_in_db
          end
        end


      end
    end

  end


end
