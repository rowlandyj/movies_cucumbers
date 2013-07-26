class Rating < ActiveRecord::Base

  attr_accessible :movie_id, :user_id, :viewable,  :rating_value
  belongs_to :movie
  belongs_to :user
  
end