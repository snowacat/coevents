NewsKeeper::Application.routes.draw do
  # Admin panel
  get 'login' => 'sessions#new'
  get 'logout' => 'sessions#destroy'
  get 'cancel' => 'sessions#cancel'
  get 'admin' => 'admin#show'
  get 'index' => 'admin#index'

  # Events
  get 'events' => 'admin#event'
  get 'events/create' => 'admin#edit'
  get 'events/update' => 'admin#edit'
  get 'events/notifications' => 'admin#send_notifications'

  # Users
  get 'users' => 'admin#user'
  get 'users/new' => 'admin#update'
  get 'find_users' => 'admin#find_users'
  get 'user/update' => 'admin#update'
  get 'destroy_user' => 'admin#destroy_user'
  post 'user' => 'admin#user_update'

  # Categories
  get 'categories' => 'admin#category'
  get 'destroy' => 'admin#destroy'
  get 'category' => 'admin#category'
  get 'edit_category' => 'admin#edit_category'
  get 'category_destroy' => 'admin#category_destroy'
  post 'create' => 'admin#create'
  post 'edit_category' => 'admin#update_category'

  # Statistics
  get 'statistics' => 'event#summury_statistics'

  resources :password_resets
  resources :admins, only: [:create, :new]
  resources :sessions, only: [:create]

  get ':controller/:action(/:id)(/:page)'
  get 'event/:id/:page', to: 'events#show'
  get 'send_simple_message' => 'events#send_simple_message'

  root to: 'admin#index'
end
