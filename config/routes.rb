Rails.application.routes.draw do

  resources :projects

  get '/admin' => 'admin_sessions#new'
  post 'admin' => 'admin_sessions#create'
  get '/admin_logout' => 'admin_sessions#destroy'
  delete 'admin_logout' => 'admin_sessions#destroy'

  get '/login' => 'sessions#new'
  post 'login' => 'sessions#create'
  get '/logout' => 'sessions#destroy'
  delete 'logout' => 'sessions#destroy'

end
