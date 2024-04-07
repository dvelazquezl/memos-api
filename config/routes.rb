Rails.application.routes.draw do
  root 'status#index'
  post '/login', to: 'auth#token'

  resources :offices, only: [:index, :create]
  resources :users, only: [:index, :create] do
    collection do
      get :me
      scope 'me' do
        patch 'update-password', to: :update_password
      end
    end
  end
end
