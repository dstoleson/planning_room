Rails.application.routes.draw do

  resources :projects
  get '/projects/project_type/:project_type_name', to: 'projects#index'

  get '/login' => 'sessions#new'
  post 'login' => 'sessions#create'

  delete 'logout' => 'sessions#destroy'
  get '/logout' => 'sessions#destroy'
end
