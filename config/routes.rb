Rails.application.routes.draw do
  devise_for :users
  namespace :admin do
    resources :posts do
      resources :comments
    end 
  end
  resources :posts do
      resources :comments
    end 
  root "posts#index"
end
