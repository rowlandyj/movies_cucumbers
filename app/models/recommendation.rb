class Recommendation < ActiveRecord::Base
  attr_accessible :movie_id, :user_id

  belongs_to :user
  belongs_to :movie

  validates_uniqueness_of :user_id, :scope => [:movie_id]
  validates :user_id, :movie_id, presence: true

end
