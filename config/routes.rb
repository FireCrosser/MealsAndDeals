Rails.application.routes.draw do
  get 'home/index'

  devise_for :users, path: ''
  root to: "home#index"
  get 'auth-token', to: "home#auth_token", as: "get_auth_token"
  resources :users
  resources :courses, only: [:index, :create]
  resources :course_types, path: "course-types", only: [:index]
  resources :orders, only: [:index, :create] do
    get 'today', to: 'today_index', on: :collection
  end
end
