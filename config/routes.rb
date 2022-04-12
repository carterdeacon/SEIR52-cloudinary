Rails.application.routes.draw do
  root "animals#new"
  resources :animals
  
end
