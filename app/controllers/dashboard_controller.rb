class DashboardController < ApplicationController
  before_filter :ensure_current_user

  def index
    @user_recipes = current_user.recipes
  end
end