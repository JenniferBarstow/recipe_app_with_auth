require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do

  before :each do @admin_user = User.create(
      first_name: "John",
      last_name: "Snow",
      email: "johnsnow@example.com",
      password: "password",
      password_confirmation: "password",
      admin: true
     )
    session[:user_id] = @admin_user.id
  end

  describe "GET #index" do
    it "returns a success response for logged in admin" do
      
      get :index
      
      expect(response.status).to eq(200)
      expect(response).to render_template :index

    end

    it "redirects non admin logged in user" do
      session.destroy

      user = User.create(
        first_name: "Bruce",
        last_name: "Wayen",
        email: "batman@example.com",
        password: "password",
        password_confirmation: "password",
        admin: false
      )

      session[:user_id] = user.id

      get :index

      expect(response.status).to eq(302)
      expect(response).to redirect_to recipes_path
      expect(response).to_not render_template :index
    end
  end

  describe "GET #show" do
    it "shows admin an individual user" do

      user = User.create(
        first_name: "Bruce",
        last_name: "Wayen",
        email: "batman@example.com",
        password: "password",
        password_confirmation: "password",
        admin: false
      )

      get :show, id: user.id

      expect(response.status).to eq(200)
      expect(response).to render_template :show
      expect(assigns(:user)).to eq user
    end

    it "redirects unathenticated user" do
      session.destroy

      user = User.create(
        first_name: "Bruce",
        last_name: "Wayen",
        email: "batman@example.com",
        password: "password",
        password_confirmation: "password",
        admin: false
      )

      session[:user_id] = user.id

      get :show, id: user.id  

      expect(response.status).to eq(302)
      expect(response).to redirect_to recipes_path
      expect(response).to_not render_template :show
    end
  end

  describe "GET #new" do
    it "renders new user form for admin" do

      get :new

      expect(response.status).to eq(200)
      expect(response).to render_template :new
      expect(assigns(:user)).to be_a_new(User)
    end

    it "prohibits non admin user from accessing new user view" do
      session.destroy

      user = User.create(
        first_name: "Bruce",
        last_name: "Wayen",
        email: "batman@example.com",
        password: "password",
        password_confirmation: "password",
        admin: false
      )

      session[:user_id] = user.id

      get :new, id: 500  

      expect(response.status).to eq(302)
      expect(response).to redirect_to recipes_path
      expect(response).to_not render_template :new
    end
  end

  describe "GET #show" do
    it "shows admin and individual user" do

      user = User.create(
        first_name: "Bruce",
        last_name: "Wayen",
        email: "batman@example.com",
        password: "password",
        password_confirmation: "password",
        admin: false
      )

      get :show, id: user.id

      expect(response.status).to eq(200)
      expect(response).to render_template :show
      expect(assigns(:user)).to eq user
    end

    it "redirects a non-admin logged in user" do
      session.destroy

        user = User.create(
        first_name: "Bruce",
        last_name: "Wayen",
        email: "batman@example.com",
        password: "password",
        password_confirmation: "password",
        admin: false
      )

      session[:user_id] = user.id

      get :show, id: 500  

      expect(response.status).to eq(302)
      expect(response).to redirect_to recipes_path
      expect(response).to_not render_template :show
    end
  end
#***************************************************************************
  describe "POST #create" do
    it "admin can create a new user" do

      expect { 
        post :create, user: 
          {
            first_name: "Jane",
            last_name: "doe",
            email: "janedoe@example.com",
            password: "password",
            password_confirmation: "password"
          }}.to change {User.all.count}.by(1)
    end

    it "redirects unathenticated user" do
      session.destroy

      user = User.create(
        first_name: "Bruce",
        last_name: "Wayen",
        email: "batman@example.com",
        password: "password",
        password_confirmation: "password",
        admin: false
      )

      session[:user_id] = user.id

      post :create 

      expect(response.status).to eq(302)
      expect(response).to redirect_to recipes_path
    end
  end

  describe "GET #edit" do
    it "lets admin a user" do 
 
      user = User.create(
        first_name: "Bruce",
        last_name: "Wayen",
        email: "batman@example.com",
        password: "password",
        password_confirmation: "password",
        admin: false
      )

      get :edit, id: user.id

      expect(response).to render_template :edit
      expect(response.status).to eq(200)
      expect(assigns(:user)).to eq user
    end

    it "doesn't allow non-admins to edit a user" do

      get :edit, id: user.id

      expect(response.status).to eq(302)
      expect(response).to redirect_to recipes_path
    end
  end

  describe "PATCH update" do
    it "allows an admin to update a user" do

      user = User.create(
        first_name: "Bruce",
        last_name: "Wayen",
        email: "batman@example.com",
        password: "password",
        password_confirmation: "password",
        admin: false
      )
      
      patch :update, id: user.id,
      user:
      { first_name: "Bruce",
        last_name: "Batman",
        email: "brue@example.com",
        password: "password",
        password_confirmation: "password"
      }

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