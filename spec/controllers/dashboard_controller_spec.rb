require 'rails_helper'

RSpec.describe DashboardController, type: :controller do

  describe "GET #index" do

    it "renders users dashboard" do
      user = User.create(
        first_name: "Dylan",
        last_name: "Ham",
        email: "dylan@example.com",
        password: "password",
        password_confirmation: "password"
      )

      session[:user_id] = user.id

      get :index

      user_recipe1 = Recipe.create(name: "brownies", ingredients: "coco, butter", instructions: "stir", user_id: user.id)
      user_recipe2 = Recipe.create(name: "cookies", ingredients: "flour, butter", instructions: "bake", user_id: user.id)
      not_user_recipe2 = Recipe.create(name: "pancakes", ingredients: "flour, sugar", instructions: "flip", user_id: nil)

      expect(response.status).to eq(200)
      expect(response).to render_template :index
      expect(assigns(:user_recipes)).to eq [user_recipe1, user_recipe2]
    end
  end
end