class SessionsController < ApplicationController
  skip_before_filter :ensure_current_user, only: :new

  def new
  end

  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password]) 
      session[:user_id] = user.id
      if user.admin
        redirect_to admin_dashboard_index_path
      else
      redirect_to dashboard_index_path
      end
    else
      @sign_in_error = "Email / password combination is invalid"
      render :new
    end
  end

  def destroy
    session.clear
    flash[:notice] = "See ya next time!"
    render :new
  end

end