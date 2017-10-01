class Admin::DashboardController < ApplicationController
  before_filter :verify_is_admin
  before_filter :ensure_current_user

  def index
    @recipes = Recipe.all
    @users = User.all
  end

  private

  def verify_is_admin
    if !current_user.is_admin?
      flash.notice = "Sorry, you can't view this page"
      redirect_to recipes_path
    end
  end

end
