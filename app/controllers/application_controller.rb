class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end

  # before_filter :require_login

  # private

  # def require_login
  #   unless current_user
  #     redirect_to new_user_session_path
  #   end
  # end

end
