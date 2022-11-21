Rails.application.routes.draw do
  devise_scope :user do
    get 'users', to: 'devise/sessions#new'
  end

  devise_for :users
  resources :users, only: %i[show]

  resources :tasks do
    member do
      put 'update_status'
    end
  end

  root 'tasks#index'
end
