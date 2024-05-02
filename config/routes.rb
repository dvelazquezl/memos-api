Rails.application.routes.draw do
  root 'status#index'
  post '/login', to: 'auth#token'

  namespace :offices do
    get '', action: :index
    post '', action: :create
  end

  namespace :users do
    get '', action: :index
    post '', action: :create
    get 'me', action: :me
    patch 'me/update-password', action: :update_password
    patch 'update-role/:ci', action: :update_role
    delete ':ci', action: :delete
  end

  namespace :memos do
    get '', action: :index
    post '', action: :create
    get '/sent', action: :sent
  end

  namespace :memo_histories do
    get '', action: :index
  end
end
