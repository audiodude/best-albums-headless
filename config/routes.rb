Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  get 'albums/index'
  get 'albums/new'
  get 'albums/create'
  get 'albums/show'
  get 'albums/edit'
  get 'albums/update'
  get 'albums/destroy'
  get 'albums/search'
  devise_for :users

  root to: "home#index"
end
