Rails.application.routes.draw do
  get 'users/new'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'session#new'

  get '/signup', to: 'users#new'

  get  '/login', to: 'session#new'
  post '/login', to: 'session#create'
  #get '/help', to: 'static_pages#help'
  #help_path -> /help
  #help_url  -> http://www.example.com
end
