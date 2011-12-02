WSMA::Application.routes.draw do

  resources :admin

  resources :houses

  resources :chores

  resources :shifts

  resources :assignments

  resources :fining_periods

  resources :fines

  resources :preferences

  resources :user_hour_requirements

  resources :house_hour_requirements

  resources :houses

  resources :users
  
  resources :demo
  
  #match "/demo/login" => "users#login"
  match "/demo/chores" => "chores#new"
  #match "/demo/profile" => "users#profile"
  match "/demo/myshift" => "users#myshift"
  match "/user/myshift" => "users#myshift"

  match "/demo/advance_time"
  match "/demo/mock_time"
  match "/demo/real_time"
  
  match "/user/managefines" => "users#manage"
  match "/user/profile" => "users#profile"

  match "/users/change_password/:id" => "users#change_password"
  match "/login" => "users#login"
  match "/logout" => "users#logout"

  match "/manageshifts" => "shifts#manageshifts"
  match "/createChore" => "chores#createChore"
  match "/quickassign" => "assignments#quickcreate"
  match "users/find_by_name/:name" => "users#find_by_name"
  match "assignments/find/:shift_id/:user_id" => "assignments#find"
  match "/setprefs" => "preferences#set_prefs"
  
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
    root :to => 'demo#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end

