Rails.application.routes.draw do
  get 'albums/index'
  get 'albums/new'
  get 'albums/create'
  get 'albums/show'
  get 'albums/edit'
  get 'albums/update'
  get 'albums/destroy'
  get 'albums/search'
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "home#index"
end
