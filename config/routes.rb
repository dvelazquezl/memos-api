Rails.application.routes.draw do
  root 'status#index'
  post '/login', to: 'auth#token'

  namespace :offices do
    get '', action: :index
    post '', action: :create
    patch '/:id', action: :rename
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
    get '/received', action: :received
    get '/search', action: :search_memos
    get '/:id', action: :show
    patch '/:id', action: :update
    post '/:id/send', action: :send_memo
    post '/:id/resend', action: :resend
    post '/:id/receive', action: :receive_memo
  end

  namespace :memo_histories do
    get '', action: :index
  end
end
