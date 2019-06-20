Rails.application.routes.draw do
  get 'admins/new'
  post 'admins/new' => 'admins#create'

  get 'client_login' => 'client_sessions#new'
  post 'client_login' => 'client_sessions#create'
  get 'client_logout' => 'client_sessions#destroy'

  get 'admin_login' => 'admin_sessions#new'
  post 'admin_login' => 'admin_sessions#create'
  get 'admin_logout' => 'admin_sessions#destroy'

  get 'client_competition' => 'client_ui#competition'
  get 'client_profile' => 'client_ui#profile'
  get 'client_group' => 'client_ui#group'
  get 'client_group/:id' => 'client_ui#group_detail'
  get 'client_create_group/:id' => 'client_ui#create_group'

  resources :colleges
  resources :teachers
  resources :students

  get 'welcome/index'
  root 'welcome#index'
end
