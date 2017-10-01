class RecipesController < ApplicationController
  before_filter :verify_is_admin, only: [:edit, :update, :destroy]
  before_filter :ensure_current_user

  def index
    @recipes = Recipe.all
  end

  def new
    @recipe = Recipe.new
  end

  def create
    @recipe = current_user.recipes.new(recipe_params)
    if @recipe.save
      redirect_to recipes_path
    else
      render :new
    end
  end 

  def show
    @recipe = Recipe.find(params[:id])
    respond_to do |format|
      format.html do
      end
      format.json do
        render json: @recipe
      end
    end
  end

  def edit
    @recipe = Recipe.find(params[:id])
  end

  def update
    @recipe = Recipe.find(params[:id])
    if @recipe.update(recipe_params)
      redirect_to recipe_path(@recipe)
    else
      render :edit
    end
  end

  def destroy
    Recipe.destroy(params[:id])
    redirect_to recipes_path
  end

  private

  def verify_is_admin
    if !current_user.is_admin?
      flash.notice = "Sorry, you can't view this page"
      redirect_to recipes_path
    end
  end


  def recipe_params
    params.require(:recipe).permit(:name, :ingredients, :instructions, :user_id )
  end

end