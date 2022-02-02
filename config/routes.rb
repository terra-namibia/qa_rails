Rails.application.routes.draw do
  resources :scores
  resources :users
  root 'scores#hello'
  post 'user_scores', to: 'scores#user_scores'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
