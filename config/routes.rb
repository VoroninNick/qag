Rails.application.routes.draw do
  scope "(:locale)" do

    get 'featured_events', to: 'home#featured_events', as: :featured_events

    devise_for :users, controllers:{ event_subscriptions: 'event_subscriptions' }, skip: [:sessions, :passwords, :confirmations, :registrations] do
     # get "accounts/signedup", :to => "users/accounts/registrations#signedup", :as => "signedup_registration"
      #get 'event/*tags/:item/register', to: 'users/event_subscriptions#new', as: :register_on_event
    end

    devise_scope :user do

      get 'event/:event_id/register', to: 'users/event_subscriptions#new', as: 'new_event_subscription'
      match 'event/:event_id/register', to: 'users/event_subscriptions#create', as: 'create_event_subscription', via: [ :post, :patch ]
      get 'event/:event_id/unregister', to: 'users/event_subscriptions#unsubscribe_form', as: 'event_unsubscription_form'
      post 'event/:event_id/unregister', to: 'users/event_subscriptions#unsubscribe', as: 'event_unsubscribe'

      get "events/history", to: "events#history", as: :events_history

      # session handling
      get     '/my/dashboard/login'  => 'users/sessions#new',     as: 'new_user_session'
      post    '/my/dashboard/login'  => 'users/sessions#create',  as: 'user_session'
      match  '/my/dashboard/logout' => 'users/sessions#destroy', as: 'destroy_user_session', via: [:post, :delete]
      get '/my/dashboard/logout', to: 'users/sessions#destroy_form', as: 'user_session_destroy_form'


      # joining
      get   '/my/dashboard/join' => 'users/registrations#new',    as: 'new_user_registration'
      post  '/my/dashboard/join' => 'users/registrations#create', as: 'user_registration'
      put   '/my/dashboard/join' => 'users/registrations#update'
      delete '/my/dashboard/join' => 'users/registrations#destroy'

      scope '/my/dashboard/account' do
        # password reset
        get   '/reset-password'        => 'users/passwords#new',    as: 'new_user_password'
        put   '/reset-password'        => 'users/passwords#update', as: 'user_password'
        post  '/reset-password'        => 'users/passwords#create'
        get   '/reset-password/change' => 'users/passwords#edit',   as: 'edit_user_password'

        get '/change-password', to: 'users/passwords#edit_password', as: 'my_edit_user_password'
        match '/change-password', to: 'users/passwords#update_password', as: 'my_update_user_password', via: [:post, :put]

        # confirmation
        get   '/confirm'        => 'users/confirmations#show',   as: 'user_confirmation'
        post  '/confirm/send'        => 'users/confirmations#create', as: 'create_user_confirmation'
        get   '/confirm/resend' => 'users/confirmations#new',    as: 'new_user_confirmation'

        # settings & cancellation
        get '/cancel'   => 'users/registrations#cancel', as: 'cancel_user_registration'
        get '/settings' => 'users/registrations#edit',   as: 'edit_user_registration'
        put '/settings' => 'users/registrations#update'

        # account deletion
        delete '' => 'users/registrations#destroy'#, as: 'delete_user_registration'
      end
  end

    post 'message', to: 'messages#create', as: 'create_message'

    get 'contact', to: 'contact#index', as: :contact

    get 'articles', to: 'articles#list', as: :articles_list

    get 'articles/:item', to: 'articles#item', as: :article_item

    get 'events/(:tag)', to: 'events#list', as: :events_list

    get 'events/:tag', to: 'events#tag', as: :event_tag

    get 'event(/*tags)/:item/register', to: 'users/event_subscriptions#new', as: :register_on_event

    get 'event(/*tags)/:item', to: 'events#item', as: :event_item



    get 'about', to: 'about#index', as: :about

    get 'test', to: 'test#index'
    get 'test/rendering', to: 'test#rendering'

    get '/data/:page', to: 'data#index'

    mount Ckeditor::Engine => '/ckeditor'
    mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
    
    
    

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
