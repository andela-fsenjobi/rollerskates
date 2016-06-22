TodoApplication.routes.draw do
  root "items#index"
  resources :posts
  resources :items
  resources :comments
end
