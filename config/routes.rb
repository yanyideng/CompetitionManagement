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
  get 'client_group/:id/edit' => 'client_ui#edit_group'
  post 'client_group/update' => 'client_ui#update_group'
  get 'client_group/:id/add_achievement' => 'client_ui#add_achievement'
  post 'client_group/add_achievement' => 'client_ui#group_add_achievement'
  post 'client_create_group' => 'client_ui#create_group'
  get 'edit_email' => 'client_ui#edit_email'
  post 'change_email' => 'client_ui#change_email'
  get 'edit_password' => 'client_ui#edit_password'
  post 'change_password' => 'client_ui#change_password'

  resources :colleges
  resources :teachers
  resources :students
  resources :competitions
  resources :achievements
  resources :groups

  get 'welcome/index'
  root 'welcome#index'
end
