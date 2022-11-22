Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }

  resources :users, only: %i[show]

  resources :tasks do
    member do
      put 'update_status'
    end
  end

  root 'tasks#index'
end
