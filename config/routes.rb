Rails.application.routes.draw do
  get 'static_pages/home'

  get 'static_pages/help'
  root 'application#welcome'
  
  get 'users/new'
  get  '/signup',  to: 'users#new'
  post '/signup',  to: 'users#create'
  
  resources :users
end
