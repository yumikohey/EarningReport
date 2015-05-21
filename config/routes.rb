Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  root 'stocks#index'

  post 'stocks/create' => 'stocks#create'

  get '/stocks/:symbol', to: 'stocks#show', as: 'stock_symbol'

  get '/earning_calendars/month_er', to: 'earning_calendars#month_er', as:'earning_calendar'

  get '/put_call_ratios/index', to: 'put_call_ratios#index'
  
  get '/put_call_ratios/data', :defaults => { :format => 'json' }

  get '/put_call_ratios/download_pcratio', to: 'put_call_ratios#download_pcratio'

  post '/put_call_ratios/create', to:'put_call_ratios#create'

  get '/earning_calendars/index', to: 'earning_calendars#index'

  get '/earning_calendars/yahoo', to: 'earning_calendars#record_earning_dates'

  get '/option_chains/:symbol', to: 'stocks#options', as: 'stock_options'

  post '/download_option_chains', to: 'stocks#download_options', as: 'download_options'

  get '/current_pain', to: 'stocks#current_pain', as: 'current_pain'


  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
