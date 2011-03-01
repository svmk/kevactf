Kevactf::Application.routes.draw do
  #resources :news
  resources :users
  resources :quests
  #resources :comments
  match 'auth/' => 'auth#index'
  match 'auth/login' => 'auth#login'
  match 'auth/logout' => 'auth#logout'
  match 'news/' => 'news#index'
  match 'news/new' => 'news#new'
  match 'news/create' => 'news#create'
  match 'news/:id' => 'news#show'
  match 'news/:id#comments/' => 'news#comments'
  match 'news/:id/add_comment/' => 'news#new_comment'
  match 'news/:id/create_comment/' => 'news#create_comment'
  match 'news/:news_id/comment/:id/remove_comment/' => 'news#remove_comment'
  match 'news/:id/edit' => 'news#edit'
  match 'news/:id/update' => 'news#update'
  match 'news/:id/delete' => 'news#destroy'
  match 'quests/' => 'quests#index'
  match 'quests/:id/' => 'quests#show'
  match 'quests/:id/answer' => 'quests#answer'
  match 'quest_type/new' => 'quest_types#new'
  match 'quest_type/create' => 'quest_types#create'
  match 'quest_type/' => 'quest_types#index_quest_type'
  match 'quest_type/:id/' => 'quest_types#show_quest_type'
  match 'quest_type/:id/edit' => 'quest_types#edit'
  match 'quest_type/:id/update' => 'quest_types#update'
  match 'quest_type/:id/delete' => 'quest_types#destroy'
  match 'scoreboard/' => 'score_board#index'
  match 'admin/' => 'admin#index'
  match 'admin/update/' => 'admin#update'
  match 'admin/send_passwords/' => 'admin#send_passwords'
  match 'users/:id/' => 'users#show'
  match 'users/:id/delete' => 'users#destroy'
  match 'users/:id/edit' => 'users#edit'
  match 'register/' => 'users#register'
  match 'activate/:key' => 'users#activate'
  match 'user_not_exists' => 'users#message_fail'
  match 'registration_complete' => 'users#message_ok'
  match 'do_register/' => 'users#do_register'
  match 'check_email/' => 'users#check_email'
  match 'email_error/' => 'users#email_error'
  match 'countdown/' => 'countdown#index'
  root :to => "main_page#index"
#  resources :quests
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

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
