Rails.application.routes.draw do

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  #root 'stocks#index'

  root 'landing#index'

  get    'register'  => 'users#new'
  get    'login'     => 'sessions#new'
  post   'login'     => 'sessions#create'
  delete 'logout'    => 'sessions#destroy'
  resources :users

end
