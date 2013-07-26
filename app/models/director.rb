class Director < ActiveRecord::Base

  attr_accessible :name
  has_many :directors_movies
  has_many :movies, through: :directors_movies
end
