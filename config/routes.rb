Rails.application.routes.draw do
  get 'admins/new'
  post 'admins/new' => 'admins#create'

  get 'client_login' => 'client_sessions#new'
  post 'client_login' => 'client_sessions#create'
  delete 'client_logout' => 'client_sessions#destroy'

  get 'admin_login' => 'admin_sessions#new'
  post 'admin_login' => 'admin_sessions#create'
  delete 'admin_logout' => 'admin_sessions#destroy'

  resources :colleges
  resources :teachers
  resources :students

  get 'welcome/index'
  root 'welcome#index'
end
