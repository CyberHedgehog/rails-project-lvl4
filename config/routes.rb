# frozen_string_literal: true

Rails.application.routes.draw do
  scope module: :web do
    root to: 'home#index'
  end
end
