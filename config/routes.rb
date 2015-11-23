Rails.application.routes.draw do

  get "m", to: "test#media_queries"

  scope "(:locale)", locale: /[a-zA-Z]{2}/ do
    post "/enable_event_substription", to: "events#enable_event_subscription"



    get 'home/future_events_thumbnails', to: 'home#future_events_thumbnails', as: :home_future_events_thumbnails, defaults: { route_name: 'home_future_events_thumbnails' }
    get 'home/prev_events_thumbnails', to: 'home#prev_events_thumbnails', as: :home_prev_events_thumbnails, defaults: { route_name: 'home_prev_events_thumbnails' }

    get 'home/event_info', to: 'home#event_info', as: :home_event_info, defaults: { route_name: 'home_event_info' }

    get 'featured_events', to: 'home#featured_events', as: :featured_events, defaults: { route_name: 'featured_events' }

    devise_for :users, controllers:{ event_subscriptions: 'event_subscriptions' }, skip: [:sessions, :passwords, :confirmations, :registrations] do
     # get "accounts/signedup", :to => "users/accounts/registrations#signedup", :as => "signedup_registration"
      #get 'event/*tags/:item/register', to: 'users/event_subscriptions#new', as: :register_on_event
    end

    devise_scope :user do

      get 'event/:event_id/register', to: 'users/event_subscriptions#new', as: 'new_event_subscription', defaults: { route_name: 'new_event_subscription' }
      match 'event/:event_id/register', to: 'users/event_subscriptions#create', as: 'create_event_subscription', via: [ :post, :patch ], defaults: { route_name: 'create_event_subscription' }
      get 'event/:event_id/unregister', to: 'users/event_subscriptions#unsubscribe_form', as: 'event_unsubscription_form', defaults: { route_name: 'event_unsubscription_form' }
      post 'event/:event_id/unregister', to: 'users/event_subscriptions#unsubscribe', as: 'event_unsubscribe', defaults: { route_name: 'event_unsubscribe' }

      get "events/history", to: "events#history", as: :events_history, defaults: { route_name: 'events_history' }

      # session handling
      get     '/my/dashboard/login'  => 'users/sessions#new',     as: 'new_user_session', defaults: { route_name: 'new_user_session' }
      post    '/my/dashboard/login'  => 'users/sessions#create',  as: 'user_session', defaults: { route_name: 'user_session' }
      match  '/my/dashboard/logout' => 'users/sessions#destroy', as: 'destroy_user_session', via: [:post, :delete], defaults: { route_name: 'destroy_user_session' }
      get '/my/dashboard/logout', to: 'users/sessions#destroy_form', as: 'user_session_destroy_form', defaults: { route_name: 'user_session_destroy_form' }


      # joining
      get   '/my/dashboard/join' => 'users/registrations#new',    as: 'new_user_registration', defaults: { route_name: 'new_user_registration' }
      post  '/my/dashboard/join' => 'users/registrations#create', as: 'user_registration', defaults: { route_name: 'user_registration' }
      put   '/my/dashboard/join' => 'users/registrations#update', as: 'update_user_regitration', defaults: { route_name: 'update_user_regitration' }
      delete '/my/dashboard/join' => 'users/registrations#destroy', as: 'destroy_user_registration', defaults: { route_name: 'destroy_user_registration' }

      scope '/my/dashboard/account' do
        # password reset
        get   '/reset-password'        => 'users/passwords#new',    as: 'new_user_password', defaults: { route_name: 'new_user_password' }
        put   '/reset-password'        => 'users/passwords#update', as: 'user_password', defaults: { route_name: 'user_password' }
        post  '/reset-password'        => 'users/passwords#create'
        get   '/reset-password/change' => 'users/passwords#edit',   as: 'edit_user_password', defaults: { route_name: 'edit_user_password' }

        get '/change-password', to: 'users/passwords#edit_password', as: 'my_edit_user_password', defaults: { route_name: 'my_edit_user_password' }
        match '/change-password', to: 'users/passwords#update_password', as: 'my_update_user_password', via: [:post, :put], defaults: { route_name: 'my_update_user_password' }

        # confirmation
        get   '/confirm'        => 'users/confirmations#show',   as: 'user_confirmation', defaults: { route_name: 'user_confirmation' }
        post  '/confirm/send'        => 'users/confirmations#create', as: 'create_user_confirmation', defaults: { route_name: 'create_user_confirmation' }
        get   '/confirm/resend' => 'users/confirmations#new',    as: 'new_user_confirmation', defaults: { route_name: 'new_user_confirmation' }

        # settings & cancellation
        get '/cancel'   => 'users/registrations#cancel', as: 'cancel_user_registration', defaults: { route_name: 'cancel_user_registration' }
        get '/settings' => 'users/registrations#edit',   as: 'edit_user_registration', defaults: { route_name: 'edit_user_registration' }
        put '/settings' => 'users/registrations#update', as: 'update_user_registration', defaults: { route_name: 'update_user_registration' }
        post "/settings/:attribute", to: 'users/registrations#update_attribute', as: :update_user_attribute, defaults: { route_name: 'update_user_attribute' }

        # account deletion
        delete '' => 'users/registrations#destroy'#, as: 'delete_user_registration'
      end
  end

    post 'message', to: 'messages#create', as: 'create_message', defaults: { route_name: 'create_message' }

    get 'contact', to: 'contact#index', as: :contact, defaults: { route_name: 'contact' }

    get 'articles', to: 'articles#list', as: :articles_list, defaults: { route_name: 'articles_list' }

    get 'articles/:item', to: 'articles#item', as: :article_item, defaults: { route_name: 'article_item' }

    get 'events/(:tag)', to: 'events#list', as: :events_list, defaults: { route_name: 'events_list' }

    get 'events/:tag', to: 'events#tag', as: :event_tag, defaults: { route_name: 'event_tag' }

    get 'event(/*tags)/:item/register', to: 'users/event_subscriptions#new', as: :register_on_event, defaults: { route_name: 'register_on_event' }

    get 'event(/*tags)/:item', to: 'events#item', as: :event_item, defaults: { route_name: 'event_item' }



    get 'about', to: 'about#index', as: :about, defaults: { route_name: 'about' }

    get 'test', to: 'test#index', as: :test_index, defaults: { route_name: 'test_index' }
    get 'test/rendering', to: 'test#rendering', as: :test_rendering, defaults: { route_name: 'test_rendering' }

    get '/data/:page', to: 'data#index', as: :data_index, defaults: { route_name: 'data_index' }

    mount Ckeditor::Engine => '/ckeditor'
    mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
    
    
    

    root to: 'home#index', defaults: { route_name: 'root' }
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
