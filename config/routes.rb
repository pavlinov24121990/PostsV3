# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  namespace :admin do
    resources :posts, except: %i[show new] do
      resources :comments, only: %i[update destroy] do
        member do
          patch :mark_destroy
        end
      end
    end
  end
  resources :posts, only: %i[index show] do
    resources :comments, only: %i[create edit update]
  end
  root 'posts#index'
end
