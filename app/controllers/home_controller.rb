class HomeController < ApplicationController
  def index
    if current_user
      redirect_to recommendations_path
    # else
  		# get_upcoming_movies
  	end
  end
end