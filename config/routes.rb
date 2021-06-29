Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :albums
  get 'albums/search'
  devise_for :users

  root to: "home#index"
end
