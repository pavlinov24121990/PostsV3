Rails.application.routes.draw do
  devise_for :users
  namespace :admin do
    resources :posts do
      resources :comments do
        post :approve, on: :member
      end
    end 
  end
  resources :posts do
      resources :comments
    end 
  root "posts#index"
end
