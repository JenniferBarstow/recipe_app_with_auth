require 'rails_helper'

feature 'Admin should be able to manage saved recipes' do

  before do
    user = User.create(
      first_name: "John",
      last_name: "Snow",
      email: "john@example.com",
      password: "password",
      password_confirmation: "password",
      admin: true
    )

    visit root_path

    click_on 'Sign In'

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Sign in'

    visit admin_dashboard_index_path
  end

  scenario 'admin should be able to visit their dashboard' do
    expect(current_path).to eq admin_dashboard_index_path
    expect(page).to have_content 'John\'s Admin Dashboard'
  end

  scenario 'admin can manage saved recipes' do
    recipe1 = Recipe.create(name: "bread", ingredients: "flour, salt", instructions: "mix it", user_id: 1)
    recipe2 = Recipe.create(name: "pho", ingredients: "rice noodles, broth", instructions: "stir", user_id: 2)
    recipe3 = Recipe.create(name: "boba", ingredients: "milk, tea", instructions: "shake it", user_id: 3)

    click_on 'edit'

    expect(current_path).to eq edit_recipe_path
  end
end