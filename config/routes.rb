# -*- encoding : utf-8 -*-
NongMin365::Application.routes.draw do
  mount RailsAdmin::Engine => '/railsadmin', :as => 'rails_admin'

  root :to => 'home#index'
  get 'search' => 'home#search', :as => :search
  get 'signup' => 'users#new', :as => :signup
  get 'signin' => 'sessions#new', :as => :signin
  delete 'signout' => 'sessions#destroy', :as => :signout
  post 'ajax/regions' => 'ajax#regions', :as => :regions_ajax

  resources :users, :only => [:create], :path => 'account' do
    collection do
      get 'password' => 'users#change_password', :as => :change_password
      get 'items' => 'users#my_items', :as => :my_items
      put :update_password
    end
  end

  get 'tags/:tag' => 'items#tags', :as => :items_tags
  #get 'items(.c:category)(.a:area)(.t:xtype)(.p:page)', :controller => :items, :action => :index, :as => :condition_list_items
  resources :sessions, :only =>[:create]
  resources :items do
    collection do
      get '(c:category)/(t:xtype)/(a:area)/(p:page)', :action => :index, :as => :condition_list
    end
    member do
      get 'show_hits'
    end
  end

  namespace :admincp do
    root :to => "dashboard#index"
    resources :dashboard, :only => [:index]
    resources :users
    resources :categories do
      member do
        put 'sort_up'
        put 'sort_down'
      end
    end
  end

  # The priority is based upon ordecurrent_passwordr of creation:
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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
