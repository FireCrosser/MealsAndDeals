Rails.application.routes.draw do
  get 'home/index'

  devise_for :users, path: ''
  root to: "home#index"
  resources :users
  resources :courses, only: [:index, :new, :create]
end
