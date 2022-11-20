Rails.application.routes.draw do
  devise_scope :user do
    # Redirests signing out users back to sign-in
    get 'users', to: 'devise/sessions#new'
    delete 'users', to: 'devise/sessions#new'
  end
  devise_for :users

  resources :tasks

  root 'tasks#index'
end
