# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :customers, only: %i[show create]
      resources :customer_subscriptions, only: %i[show create]
    end
  end
end
