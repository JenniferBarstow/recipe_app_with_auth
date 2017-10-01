require "rails_helper"

describe WelcomeController do
  describe "GET #index" do
    it "Should render the Welcome view" do

      get :index
      expect(response).to render_template(:index)
    end
  end
end