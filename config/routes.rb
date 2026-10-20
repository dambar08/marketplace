Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  namespace :admin do
    root "dashboard#show"
    resources :customers, only: %i[index show update]
    resources :orders, only: %i[index show]
    resources :fulfillments, only: %i[index show update]
    resources :payments, only: %i[index show]
    resources :promotions
    resources :carts, only: %i[index show update]
    resources :products, only: %i[index new create show edit update] do
      resource :thumbnail, only: :destroy, module: :products
      resources :options, only: %i[create update destroy], module: :products
      resources :variants, only: %i[create update destroy], module: :products do
        resources :prices, only: %i[create update destroy]
      end
    end
  end

  root to: redirect("/admin")
end
