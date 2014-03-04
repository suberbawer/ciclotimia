Ciclotimia::Application.routes.draw do 
  
  get "articles/devolution"
  post "articles/devolution"


  get "reports/index"
  post "reports/index"

  get "billings/index"

  post "search/index"

  resources :reports

  resources :articles
    post "articles/list"
    post "articles/filter"
    post "articles/fetch_data"

    #get "providers/articles_not_sent"

  resources :providers
  post "providers/filter"
  match 'providers_:id' => 'providers#articles_not_sent', :via => [:get], :as => 'art_not_sent'
  
  resources :transactions

  resources :sales

  resources :transactions_sales

  resources :inputs
    
    post "inputs/new_manual_input"

    post "inputs/bulk_save" 

    get "inputs/show" 

  resources :outputs
    
    post "outputs/new_manual_output" 

  resources :other_inputs

    get "collects/today_collect"

    get "collects/index"

    post "collects/close_today_caja"

    post "collects/open_today_caja"

    post "collects/close_another_caja"

    post "collects/cancel_transaction"


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

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
