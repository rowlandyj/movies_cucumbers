class Rating < ActiveRecord::Base

  attr_accessible :movie_id, :user_id, :viewable,  :rating_value
  belongs_to :movie
  belongs_to :user

  def self.rating_distributor(group_of_movies)
    if group_of_movies.rating <= 2.0
      next
    elsif group_of_movies.rating > 2.0 && group_of_movies.rating <= 3.0

    elsif group_of_movies.rating > 3.0 && group_of_movies.rating <= 4.0

    elsif group_of_movies.rating > 4.0 && group_of_movies.rating <= 5.0

    end

  end

  
end
