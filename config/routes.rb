Rails.application.routes.draw do
  get 'sessions/new'

  get 'static_pages/home'

  root 'static_pages#home'
  get  '/help',    to: 'static_pages#help'
  get  '/about',   to: 'static_pages#about'
  get  '/account', to: 'static_pages#account'
  get  '/billing', to: 'static_pages#billing'
  get  '/test', to: 'billing#show'
  
  
  post 'users/:id/hosted_page_checkout_existing' => 'users#hosted_page_checkout_existing', as: "hosted_page_checkout_existing"
  post 'users/:id/checkout_existing' => 'users#checkout_existing'
  get 'users/activate_subscription' => 'users#activate_subscription'
  get 'invoice_pdf/:id' => 'users#invoice_pdf', as: 'test_pdf'
  
  
  get 'users/new'
  get  '/signup',  to: 'users#new'
  post '/signup',  to: 'users#create'
  
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  
  resources :users
end
