require 'rails_helper'

RSpec.describe RecipesController, type: :controller do

  before :each do @user = User.create(
      first_name: "Dylan",
      last_name: "Ham",
      email: "dylan@example.com",
      password: "password",
      password_confirmation: "password"
     )
    session[:user_id] = @user.id
  end

  describe "GET #index" do
    it "returns a success response for logged in user" do
      recipe1 = Recipe.create(name: "brownies", ingredients: "coco, butter", instructions: "stir")
      recipe2 = Recipe.create(name: "cookies", ingredients: "flour, butter", instructions: "bake")
      
      get :index
      
      expect(response.status).to eq(200)
      expect(response).to render_template :index
      expect(assigns(:recipes)).to eq [recipe1, recipe2]

    end
    it "redirects unathenticated user" do
      session.destroy

      get :index

      expect(response.status).to eq(302)
      expect(response).to redirect_to signin_path
    end
  end

  describe "GET #show" do
    it "shows an individual recipe for authenticated user" do
      recipe = Recipe.create(id: 1, name: "brownies", ingredients: "coco, butter", instructions: "stir")

      get :show, id: 1

      expect(response.status).to eq(200)
      expect(response).to render_template :show
      expect(assigns(:recipe)).to eq recipe
    end

    it "redirects unathenticated user" do
      session.destroy

      get :show, id: 500  

      expect(response.status).to eq(302)
      expect(response).to redirect_to signin_path
    end
  end

  describe "GET #new" do
    it "renders new form for authenticated user" do

      get :new

      expect(response.status).to eq(200)
      expect(response).to render_template :new
      expect(assigns(:recipe)).to be_a_new(Recipe)
    end

    it "redirects unathenticated user" do
      session.destroy

      get :new, id: 500  

      expect(response.status).to eq(302)
      expect(response).to redirect_to signin_path
    end
  end

  describe "POST #create" do
    it "creates new recipe for authenticated user" do

      expect {
        post :create,
          recipe: {name: "pizza", ingredients: "cheese, peppers", instructions: "cook it"}
        }.to change {Recipe.all.count}.by(1)
    end
  end

  it "redirects unathenticated user" do
      session.destroy

      post :create 

      expect(response.status).to eq(302)
      expect(response).to redirect_to signin_path
    end

    describe "GET #edit" do
      it "lets admin edit a recipe" do 
        admin_user = User.create(
          first_name: "Liam",
          last_name: "Ham",
          email: "liam@example.com",
          password: "password",
          password_confirmation: "password",
          admin: true
        )

        recipe = Recipe.create(id: 2,name: "ice cream", ingredients: "cream, sugar", instructions: "blend")

        session[:user_id] = admin_user.id

        get :edit, id: 2

        expect(response).to render_template :edit
        expect(response.status).to eq(200)
        expect(assigns(:recipe)).to eq recipe
      end

      it "doesn't allow non-admins to edit a recipe" do

        get :edit, id: 2

        expect(response.status).to eq(302)
        expect(response).to redirect_to recipes_path
      end
    end

    describe "PATCH update" do
      it "allows an admin to update a recipe" do
        admin_user = User.create(
          first_name: "Liam",
          last_name: "Ham",
          email: "liam@example.com",
          password: "password",
          password_confirmation: "password",
          admin: true
        )

        session[:user_id] = admin_user.id
        Recipe.create(id: 3, name: "pizza", ingredients: "cheese, peppers", instructions: "cook it")
        
        patch :update, id: 3, recipe: {name: "pepperoni pizza", ingredients: "cheese, pepperoni", instructions: "cook it"}

        expect(response.status).to eq(302)
        expect(response).to redirect_to recipe_path(3)
        expect(Recipe.find(3).name).to eq("pepperoni pizza")
      end

      it "doesn't allow non-admins to update a recipe" do

        patch :update, id: 10

        expect(response.status).to eq(302)
        expect(response).to redirect_to recipes_path
      end
    end

    describe "DELETE" do
      it "allows an admin to delete a recipe" do
          admin_user = User.create(
          first_name: "Liam",
          last_name: "Ham",
          email: "liam@example.com",
          password: "password",
          password_confirmation: "password",
          admin: true
        )

        session[:user_id] = admin_user.id

        recipe = Recipe.create(id: 20, name: "ramen", ingredients: "noodles, broth", instructions: "boil it")

        delete :destroy, id: recipe.id

        expect(response.status).to eq(302)
        expect(response).to redirect_to recipes_path
        expect(Recipe.all.count).to eq(0)
      end

      it "restricts non-admins from deleting recipes" do

        recipe = Recipe.create(id: 20, name: "ramen", ingredients: "noodles, broth", instructions: "boil it")
        delete :destroy, id: recipe.id

        expect(response.status).to eq(302)
        expect(response).to redirect_to recipes_path
        expect(Recipe.all.count).to eq(1)
      end
    end

end
