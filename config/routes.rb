# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  namespace :admin do
    resources :posts, except: %i[show] do
      resources :comments, only: %i[update]
    end
  end
  resources :posts, only: %i[index show] do
    resources :comments, only: %i[create destroy edit update]
  end
  root 'posts#index'
end
