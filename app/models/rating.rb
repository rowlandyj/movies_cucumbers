class Rating < ActiveRecord::Base

  attr_accessible :movie_id, :user_id, :viewable,  :rating_value
  belongs_to :movie
  belongs_to :user

  validates_uniqueness_of :user_id, :scope => [:movie_id]

  
end
