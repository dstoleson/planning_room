Rails.application.routes.draw do

  resources :projects

  get '/login' => 'sessions#new'
  post 'login' => 'sessions#create'

  delete 'logout' => 'sessions#destroy'
  get '/logout' => 'sessions#destroy'
end
