class Genre < ActiveRecord::Base

  has_many :genres_movies
  
end