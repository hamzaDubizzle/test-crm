Rails.application.routes.draw do
  devise_for :users
  
  # Bad practice: no proper namespacing
  resources :customers
  resources :deals
  resources :tasks
  
  # Bad practice: no proper root route
  root 'customers#index'
end
