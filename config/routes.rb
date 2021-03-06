Rails.application.routes.draw do
  get 'invites/index'

  get 'invites/new'

  get 'invites/create'

  get 'invites/show'

  get 'invites/edit'

  get 'invites/update'

  get 'invites/destroy'

  root 'index#index'

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  namespace :api do
    mount_devise_token_auth_for 'User', at: 'auth', controllers: {
        registrations: 'users/registrations'
    }
  end

  # namespace :events do
  #   post '/', to: 'event#create', as: :events_create
  #   post 'around', to: 'event#visible_events', as: :events_around
  #   post 'checkin', to: 'event#checkin', as: :events_checkin
  # end
  post 'events', to: 'event#create', as: :events_create
  post 'events/around', to: 'event#visible_events', as: :events_around
  get 'events/my_events', to: 'event#my_events', as: :my_events

  post 'checkin', to: 'checkin#create', as: :events_checkin

  resources :invite

  get 'sample/events', to: 'sample#form'

  post 'sample/checkin', to: 'sample#checkin', as: :sample_checkin
  post 'sample/events', to: 'sample#events', as: :sample_event

  # The priority is based upon order of creation:
  # first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route
  # (maps HTTP verbs to controller actions automatically):
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
