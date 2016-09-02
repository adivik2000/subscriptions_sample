Rails.application.routes.draw do
  get 'static_pages/home'

<<<<<<< HEAD
  
=======
  get 'static_pages/help'
  get  'static_pages/about'
  get  '/billing', to: 'static_pages#billing'
>>>>>>> dev
  
  root 'application#welcome'
  root 'static_pages#home'
   get  '/help',    to: 'static_pages#help'
  get  '/about',   to: 'static_pages#about'
  get  '/account', to: 'static_pages#account'
  get  '/billing', to: 'static_pages#billing'
  
  
  get 'users/new'
  get  '/signup',  to: 'users#new'
  post '/signup',  to: 'users#create'
  
  resources :users
end
