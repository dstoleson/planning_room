Rails.application.routes.draw do

  resources :projects

  get '/private' => 'sessions#new'
  get '/current' => 'sessions#new'
  get '/open' => 'projects#index'

  get '/login' => 'sessions#new'
  post 'login' => 'sessions#create'
  get '/logout' => 'sessions#destroy'
  delete 'logout' => 'sessions#destroy'

  get '/admin' => 'admin_sessions#new'
  post 'admin' => 'admin_sessions#create'
  get '/admin_logout' => 'admin_sessions#destroy'
  delete 'admin_logout' => 'admin_sessions#destroy'

end
