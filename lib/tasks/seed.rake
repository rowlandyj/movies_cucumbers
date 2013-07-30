desc "Seed the database from TMDB" 
task :seed_from_tmdb,[:min_id, :max_id] => :environment do |t,args| 
    (args[:min_id]).upto(args[:max_id]) do |i|
      movie = TmdbMovie.find(id: i)
      if !movie.empty? && !movie.runtime.nil? && movie.runtime > 45

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

      puts "Added movie"
      # sleep 0.05
    end
end 

