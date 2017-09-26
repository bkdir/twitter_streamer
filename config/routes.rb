Rails.application.routes.draw do

  get '/deleted_tweets',   to: 'tweets#index'
  delete '/delete_tweet', to: 'tweets#destroy'

  get '/twitter_users', to: 'twitter_users#index'
  get '/twitter_users/:id', to: 'twitter_users#show', as: 'twitter_user'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'sessions#new'

  get  '/add_user', to: 'users#new'
  post '/add_user', to: 'users#create'
  resources :users, :except => [ :show ]

  get    '/login',    to: 'sessions#new'
  post   '/login',    to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  resources :password_resets, only: [:new, :create, :edit, :update]
  
  match '*path', to: redirect("/"), via: :all

  #help_path -> /help
  #help_url  -> http://www.example.com
end
