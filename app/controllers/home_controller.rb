class HomeController < ApplicationController
  def index
    if current_user
      redirect_to recommendations_path, :notice => 'Signed in successfully.'
    end
  end
end
