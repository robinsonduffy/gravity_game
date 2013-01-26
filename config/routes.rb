GravityGame::Application.routes.draw do
  
  
  match '/' => "pages#home", :as => 'root'
  
  match 'level/:id' => 'levels#show', :as => 'level'
  
  match 'auth/facebook/callback' => 'sessions#callback', :as => 'fb_callback'
  
  post 'ajax/complete_level' => 'ajax#complete_level'
  
  match 'collection/:id' => 'collections#show', :as => 'collection'
  post 'collection/:id/unlock' => 'collections#unlock', :as => 'collection_unlock'
  
  match 'coins' => 'coin_transactions#show', :as => 'transactions'
  
  if Rails.env == 'development'
    match 'level/:id/create' => 'levels#get_create_commands'
    match 'collection/:id/create' => 'collections#get_create_commands'
  end

  match '/level_factory', :to => 'level_factory#index', :as => 'level_factory'
  match '/level_factory/new', :to=> 'level_factory#new', :as => 'new_level_factory'
  post '/level_factory/save', :to => 'level_factory#save', :as => 'save_level_factory'
  match '/level_factory/:id', :to => 'level_factory#edit', :as => 'edit_level_factory'

  post 'level_element/:id/unlock', :to => 'level_elements#unlock', :as => 'level_element_unlock'
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
