# frozen_string_literal: true

Rails.application.routes.draw do
  post '/auth/:provider', to: 'auth#request', as: :auth_request
  get '/auth/:provider/callback', to: 'web/auth#callback', as: :callback_auth

  scope module: :web do
    resources :sessions, only: :destroy
    root to: 'home#index'
  end
end
