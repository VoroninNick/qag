Rails.application.routes.draw do
  scope "(:locale)" do
    post 'message', to: 'messages#create', as: 'create_message'

    get 'contact', to: 'contact#index', as: :contact

    get 'articles', to: 'articles#list', as: :articles_list

    get 'articles/:item', to: 'articles#item', as: :article_item

    get 'events/(:tag)', to: 'events#list', as: :events_list

    get 'events/:tag', to: 'events#tag', as: :event_tag

    get 'event/*tags/:item', to: 'events#item', as: :event_item

    get 'about', to: 'about#index', as: :about

    get 'test', to: 'test#index'
    get 'test/rendering', to: 'test#rendering'

    get '/data/:page', to: 'data#index'

    mount Ckeditor::Engine => '/ckeditor'
    mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
    devise_for :users
    root to: 'home#index'
  end

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
