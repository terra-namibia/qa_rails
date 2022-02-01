Rails.application.routes.draw do
  resources :scores
  resources :users
  root 'scores#index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
