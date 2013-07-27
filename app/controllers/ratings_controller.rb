class RatingsController < ApplicationController
  def index
    @movies = Movie.find(:all).sample(50)
  end
  def create
  end
  def new
  end
  def edit
  end
  def show
  end
  def update
  end
  def destroy
  end
end   

