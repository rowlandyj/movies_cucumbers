class Movie < ActiveRecord::Base

  REC_LIMIT = 50

  attr_accessible :title, :rt_id, :tmdb_id, :director_id,
  :critic_consensus, :rt_score, :poster_url, :trailer_url, 
  :mpaa_rating, :run_time, :imdb_ref, :tmdb_rating, :release_date,
  :budget
  has_many :ratings
  has_many :user, through: :ratings

  has_many :actors_movies
  has_many :actors, through: :actors_movies

  has_many :genres_movies
  has_many :genres, through: :genres_movies

  has_many :directors_movies
  has_many :directors, through: :directors_movies

  # def self.seed_rt(min_id, max_id)

  #   (min_id).upto(max_id) do |i|
  #     movie = RottenMovie.find(id: i)
  #     unless movie.empty?

  #       if movie.respond_to?(:links) && movie.links.respond_to?(:clips)
  #         clips_url = movie.links.clips

  #       end

  #       clips = HTTParty.get(clips_url + "?apikey=" + RT_API_KEY)
  #       unless clips['clips'].empty?
  #         trailer_url = clips['clips'].first['links']['alternate']
  #       else
  #         trailer_url = 'http://www.apple.com/trailers'
  #       end

  #       if movie.respond_to?(:posters) && movie.posters.respond_to?(:detailed)
  #         poster_url = movie.posters.detailed
  #       end

  #       movie_in_db = Movie.find_or_create_by_rt_id( title: movie.title,
  #         rt_id:  movie.id,
  #         release_year: movie.year,
  #         critic_consensus: movie.critics_consensus,
  #         rt_score: movie.ratings.critics_score,
  #         poster_url: poster_url,
  #         trailer_url: trailer_url,
  #         mpaa_rating: movie.mpaa_rating,
  #         run_time: movie.runtime
  #         )


  #       director = Director.find_or_create_by_name(name: movie.abridged_directors.first.name)
  #       director.movies << movie_in_db

  #       3.times do |index|
  #         unless movie.abridged_cast[index].nil?
  #           actor = Actor.find_or_create_by_name(name: movie.abridged_cast[index].name) 
  #           movie_in_db.actors << actor
  #         end
  #       end

  #       movie.genres.each do |genre|
  #         unless genre.nil?
  #           genre_in_db = Genre.find_or_create_by_name(name: genre)
  #           movie_in_db.genres << genre_in_db
  #         end
  #       end


  #     end


  #     sleep 0.5
  #   end

  # end


  def self.seed_tmdb(min_id, max_id)

    (min_id).upto(max_id) do |i|
      movie = TmdbMovie.find(id: i)
      if !movie.empty? && movie.runtime > 45

        unless movie.trailer.nil?
          trailer_url = movie.trailer
        else
          trailer_url = 'http://www.apple.com/trailers'
        end
        # 1 too small and 3 too big
        if movie.posters.empty?
          poster_url = "http://all3dmod.com/wp-content/uploads/2013/05/Cucumber-3D-Model.jpg"
        else
          poster_url = movie.posters[2].url
        end

        if movie.released == '' || movie.released.nil?
          release_date = Date.parse('1-1-1970')
        else
          release_date = Date.parse(movie.released)
        end

        movie_in_db = Movie.find_or_create_by_tmdb_id(title: movie.name,
          tmdb_id:  movie.id,
          release_date: release_date,
          tmdb_rating: movie.rating,
          poster_url: poster_url,
          trailer_url: trailer_url,
          mpaa_rating: movie.certification,
          run_time: movie.runtime,
          imdb_ref: movie.imdb_id,
          budget:   movie.budget)


        actors_in_film = []
        directors_in_film = []
        movie.cast.each do |cast_member|
          if cast_member.job == "Director"
            directors_in_film << cast_member.name
          elsif cast_member.job == "Actor"
            actors_in_film << cast_member.name
          end
        end

        directors_in_film.each do |director|
          movie_in_db.directors << Director.find_or_create_by_name(name: director)
        end

        #only getting top 3 actors
        3.times do |i|
          movie_in_db.actors << Actor.find_or_create_by_name(name: actors_in_film[i])
        end

        movie.genres.each do |genre|
          movie_in_db.genres << Genre.find_or_create_by_name(name: genre.name)
        end

      end


      sleep 0.3
    end

  end


    def self.movie_recommender(rated_movie)
      director = rated_movie.directors.last
      actor = rated_movie.actors.last
      genre = rated_movie.genres.last

      director_movies = Director.find(director.id).movies
      actor_movies = Actor.find(actor.id).movies
      genre_movies = Genre.find(genre.id).movies

      actor_director_genre_recs = director_movies & actor_movies & genre_movies
      actor_director_recs = director_movies & actor_movies
      director_genre_recs = director_movies & genre_movies
      genre_actor_recs = genre_movies & actor_movies
      total_recs = actor_director_genre_recs

      if total_recs.length <= REC_LIMIT
        total_recs << actor_director_recs
      end

      if total_recs.length <= REC_LIMIT
        total_recs << director_genre_recs
      end 

      if total_recs.length <= REC_LIMIT
        total_recs << actor_genre_recs
      end 

      total_recs.delete_if { |movie| movie.id == rated_movie.id }
      total_recs
    end

  end
