Timesheet::Application.routes.draw do

  get "change_password/show"
  get "change_password/edit"
  patch "change_password/update"
  get "admin/time_table/" => 'admin/time_table#index'
  get "admin/time_table/index" => 'admin/time_table#index'
  get "admin/time_table/start_date/:start_date/end_date/:end_date/" => 'admin/time_table#index', as: :time_table_range
  post "admin/time_table/update" => 'admin/time_table#update'
  get "admin/index" => 'admin/admin#index'
 
  get 'login' => 'login#index', as: :login
  get 'logout' => 'login#logout', as: :logout
  post 'authenticate' => 'login#authenticate', as: :authenticate

  namespace :admin do
    resources :employees
    resources :time_entries
  end

  get 'hours_worked/:id' => 'hours_worked#new', as: :hours_worked
  post 'hours_worked/:id' => 'hours_worked#create'
  patch 'hours_worked/:id' => 'hours_worked#create'
  delete 'delete_hours_worked/:id' => 'hours_worked#destroy', as: :delete_hours_worked

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'
  root 'login#index'

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
