require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do

  before :each do 
    User.destroy_all
    @admin_user = User.create(
      first_name: "Jennifer",
      last_name: "Snow",
      email: "jennifersnow@example.com",
      password: "password",
      password_confirmation: "password",
      admin: true
    )

    @user = User.create(
      first_name: "Bruce",
      last_name: "Wayne",
      email: "batman@example.com",
      password: "password",
      password_confirmation: "password",
      admin: false
    )    
  end

  describe "GET #index" do

    it "returns a success response for logged in admin" do
      session["user_id"] = @admin_user.id    
      
      get :index
      
      expect(response.status).to eq(200)
      expect(response).to render_template :index
    end

    it "redirects non admin logged in user" do

      session[:user_id] = @user.id

      get :index

      expect(response.status).to eq(302)
      expect(response).to redirect_to recipes_path
      expect(response).to_not render_template :index
    end
  end

  describe "GET #show" do

    it "shows admin an individual user" do

      session["user_id"] = @admin_user.id    

      get :show, id: @user.id

      expect(response.status).to eq(200)
      expect(response).to render_template :show
      expect(assigns(:user)).to eq @user
    end

    it "redirects unathenticated user" do

      session.destroy

      session[:user_id] = @user.id

      get :show, id: @user.id  

      expect(response.status).to eq(302)
      expect(response).to redirect_to recipes_path
      expect(response).to_not render_template :show
    end
  end

  describe "GET #new" do

    it "renders new user form for admin" do

      session["user_id"] = @admin_user.id    


      get :new

      expect(response.status).to eq(200)
      expect(response).to render_template :new
      expect(assigns(:user)).to be_a_new(User)
    end

    it "prohibits non admin user from accessing new user view" do

      session[:user_id] = @user.id

      get :new, id: 500  

      expect(response.status).to eq(302)
      expect(response).to redirect_to recipes_path
      expect(response).to_not render_template :new
    end
  end

  describe "GET #show" do

    it "shows admin and individual user" do
      
      session["user_id"] = @admin_user.id    

      get :show, id: @user.id

      expect(response.status).to eq(200)
      expect(response).to render_template :show
      expect(assigns(:user)).to eq @user
    end

    it "redirects a non-admin logged in user" do

      session[:user_id] = @user.id

      get :show, id: 500  

      expect(response.status).to eq(302)
      expect(response).to redirect_to recipes_path
      expect(response).to_not render_template :show
    end
  end

  describe "POST #create" do

    it "admin can create a new user" do

      session["user_id"] = @admin_user.id    

      expect { 
        post :create, user: 
          {
            first_name: "Jane",
            last_name: "doe",
            email: "janedoe@example.com",
            password: "password",
            password_confirmation: "password"
          }
      }.to change {User.all.count}.by(1)
    end

    it "redirects unathenticated user" do

      session[:user_id] = @user.id

      post :create 

      expect(response.status).to eq(302)
      expect(response).to redirect_to recipes_path
    end
  end

  describe "GET #edit" do

    it "lets admin edit a user" do 
    
      session["user_id"] = @admin_user.id    

      get :edit, id: @user.id

      expect(response).to render_template :edit
      expect(response.status).to eq(200)
      expect(assigns(:user)).to eq @user
    end

    it "doesn't allow non-admins to edit a user" do
   
      session[:user_id] = @user.id

      get :edit, id: @user.id

      expect(response.status).to eq(302)
      expect(response).to redirect_to recipes_path
    end
  end

  describe "PATCH update" do

    it "allows an admin to update a user" do

      session["user_id"] = @admin_user.id    
      
      patch :update, id: @user.id,
      user:
      { first_name: "Bruce",
        last_name: "Batman",
        email: "brue@example.com",
        password: "password",
        password_confirmation: "password"
      }

      expect(response.status).to eq(302)
      expect(response).to redirect_to admin_user_path(@user.id)
      expect(User.find(@user.id).last_name).to eq("Batman")
    end

    it "doesn't allow non-admins to update a user" do

      session[:user_id] = @user.id

      patch :update, id: 10

      expect(response.status).to eq(302)
      expect(response).to redirect_to recipes_path
    end
  end

  describe "DELETE" do

    it "allows an admin to delete a user" do

      session[:user_id] = @admin_user.id

      expect(User.all.count).to eq(2)

      delete :destroy, id: @user.id

      expect(response.status).to eq(302)
      expect(response).to redirect_to admin_users_path
      expect(User.all.count).to eq(1)
      expect(User.first["first_name"]).to eq(@admin_user.first_name)
    end

    it "restricts non-admins from deleting users" do

      session["user_id"] = @user.id    

      user3 = User.create(
        first_name: "Emmy",
        last_name: "Lou",
        email: "emmylou@example.com",
        password: "password",
        password_confirmation: "password",
        admin: false
      )

      session[:user_id] = @user.id

      delete :destroy, id: user3.id

      expect(response.status).to eq(302)
      expect(response).to redirect_to recipes_path
      expect(User.all.count).to eq(3)
    end
  end
end