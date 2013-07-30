class Movie < ActiveRecord::Base

  attr_accessible :title, :rt_id, :tmdb_id, :director_id,
  :critic_consensus, :rt_score, :poster_url, :trailer_url, 
  :mpaa_rating, :run_time, :imdb_ref, :tmdb_rating, :release_date,
  :budget
  has_many :ratings
  has_many :users, through: :ratings

  has_many :actors_movies
  has_many :actors, through: :actors_movies

  has_many :genres_movies
  has_many :genres, through: :genres_movies

  has_many :directors_movies
  has_many :directors, through: :directors_movies

  has_many :recommendations
  has_many :users, through: :recommendations

  posify do
    # The searchable content.
    [self.title].join ' '
  end




  
end

