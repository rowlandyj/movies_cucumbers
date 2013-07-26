class DirectorsMovie < ActiveRecord::Base
  
  attr_accessible :movie_id, :director_id
  belongs_to :movie
  belongs_to :director

end
