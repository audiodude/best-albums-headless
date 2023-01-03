Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  get 'albums/wikidata/:qid', to: 'albums#wikidata', as: 'album_wikidata'
  resources :albums
  devise_for :users

  root to: "home#index"

  get 'gem/index', to: 'gem#index', formats: 'gmi'
  get 'gem/:slug', to: 'gem#album', formats: 'gmi'
end
