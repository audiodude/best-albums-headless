Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :albums
  get 'albums/search'
  devise_for :users

  root to: "home#index"

  get 'gem/index', to: 'gem#index', formats: 'gmi'
  get 'gem/:slug', to: 'gem#album', formats: 'gmi'
end
