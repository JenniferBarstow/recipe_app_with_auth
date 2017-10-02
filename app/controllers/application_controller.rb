class ApplicationController < ActionController::Base

  helper_method :current_user
  protect_from_forgery with: :exception

  def current_user
    User.find_by(id: session[:user_id])
  end

  def ensure_current_user
    unless current_user
      session[:redirect_to] = request.fullpath
      flash[:notice] = "You must sign in"
      redirect_to sign_in_path
    end
  end

end
