class Genre < ActiveRecord::Base

  attr_accessible :name
  has_many :genres_movies
  has_many :movies, through: :genres_movies
  
end