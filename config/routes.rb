Rails.application.routes.draw do
  get 'main_page/index'

  devise_for :users
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'main_page#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products
  
  resources :operative_records, only: [:create, :edit, :update]
  post 'operative_records/validate' => 'operative_records#validate'
  post 'operative_records/cafap/:target_day' => 'operative_records#cafap', as: 'cafap_operative_records'
  post 'operative_records/emergency_data/:target_day' => 'operative_records#emergency_data', as: 'emergency_data_operative_records'
  #post 'operative_records/import/:target_day/:file' => 'operative_records#import', as: 'import_operative_records'
  post 'operative_records/import/:target_day' => 'operative_records#import', as: 'import_operative_records'
  get  'operative_records/all/:target_day' => 'operative_records#all', as: 'all_operative_records'
  get  'operative_records/new/:district_id/:target_day' => 'operative_records#new', as: 'new_operative_record_by'
  get  'operative_records/versions/:id' => 'operative_records#versions', as: 'versions_operative_records'
 # resources :stealing_autos

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
