class Recommendation < ActiveRecord::Base
  attr_accessible :movie_id, :user_id

  validates_uniqueness_of :user_id, :scope => [:movie_id]
  belongs_to :user
  belongs_to :movie

end
