Histvest::Application.routes.draw do
  
  get '/articles/batch_actions', to: 'articles#batch_actions', :as => :articles_batch
  get '/topics/batch_actions', to: 'topics#batch_actions', :as => :topics_batch
  get '/topics/topic_location', to: 'topics#topic_location', :as => :topic_location
  get '/users/batch_actions', to: 'users#batch_actions', :as => :users_batch
  get '/topics/get_topic_with_latlng', to: 'topics#get_topic_with_latlng'
  get '/topics/get_address_with_topic', to: 'topics#get_address_with_topic'
  get '/locations_for_topic', to: 'locations#locations_for_topic', :as => :locations_for_topic
  post '/topics/:id', to: 'topics#show'
  match '/take_another_topic', to: 'welcome#take_another_topic', :as => :take_another_topic, via: [:get,:post]
  get '/get_related_topics', to: 'welcome#get_related_topics'
  get '/search_count_for_topic', to:'welcome#search_count_for_topic'
  match '/search_stats', to: 'topics#search_stats', via: [:get,:post]

  resources :references, 
    :articles,
    :reference_sources,
    :reference_types,
    :locations,
    :users,
    :articles

  resources :topics do
    get :locations, on: :member
  end

  get 'census/1910', to: 'people#index', as: :census
  get 'person/:pfid', to: 'people#show', as: :person


  get 'misc', to: 'misc#index', :as => :misc
  post 'misc/set_article', to: 'misc#set_article' 
  post 'misc/delete-orphan-locations', to: 'misc#delete_orphan_locations', :as => :delete_orphan_locations
  post 'misc/repair_references', to: 'misc#repair_references', :as => :repair_references

 
  resources :sessions, only: [:new, :create, :destroy, :forgot_password, :get_new_password]
  resource :moderation, :only => [:show, :update]

  match 'settings', to: 'settings#index', via: [:get,:post]

  match '/signin', to: 'sessions#new', via: [:get,:post]
  match '/forgot_password', to: 'sessions#forgot_password', :as => :forgot_pass, via: [:get,:post]
  match '/get_new_password', to: 'sessions#get_new_password', :as => :get_new_password, via: [:get,:post]
  get 'reset_password/:id/:token', to: 'sessions#change_password_form', :as => :reset_password
  patch 'reset_password/:id/:token', to: 'sessions#update_new_password', :as => :update_new_password
  match '/signout', to: 'sessions#destroy', via: :delete
  match '/delete_all_topics', to: 'topics#delete_all_topics', via: [:get,:post]
  match '/show_topic_in_touch', to: 'topics#show_topic_in_touch', via: [:get,:post]
  
  get "static_pages/home"
  get "static_pages/admin"
  get '/om_histvest', to: 'static_pages#about'
  
  get '/references/search/:source/:index/:query', to: 'references#searchSource'

  get '/references/numberOfResultsNb/:query', to: 'references#numberOfResultsNb'
  get '/references/numberOfResultsWiki/:query', to: 'references#numberOfResultsWiki'
  get '/references/numberOfResultsEuro/:query', to: 'references#numberOfResultsEuro'
  get '/references/numberOfResultsDa/:query', to: 'references#numberOfResultsAr'

  resource :search, controller: :search, only: [:show] do
    get :hit
  end

  #get 'v2', to: 'pages#home'
  #get 'v2/topics', to: 'pages#topics'
  get 'v2/people', to: 'people#combined'
  
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
  
  root :to => 'welcome#index'
  get 'home-topics', to: 'welcome#index'

  # See how all your routes lay out with "rake routes"
  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
