Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'sessions#new'

  get  '/add_user', to: 'users#new'
  post '/add_user', to: 'users#create'
  resources :users

  get    '/login',    to: 'sessions#new'
  post   '/login',    to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  #help_path -> /help
  #help_url  -> http://www.example.com
end
