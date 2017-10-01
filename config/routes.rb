Rails.application.routes.draw do

  root 'welcome#index'

  resources :dashboard, only: :index
  resources :recipes

  get '/sign-up' => 'registrations#new', as: :signup
  post '/sign-up' => 'registrations#create'
  get '/sign-in' => 'sessions#new', as: :signin
  post '/sign-in' => 'sessions#create'
  get '/sign-out' => 'sessions#destroy', as: :signout

  namespace :admin do
    resources :dashboard, only: :index
    resources :users
  end
end
