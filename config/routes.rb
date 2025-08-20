Rails.application.routes.draw do
  get "schedules", to: "schedules#index", as: :schedule
  get "home/index"
  root "home#index"
  resources :bookings do
    collection do
      get "schedule"
    end
    member do
      get :confirmation
    end
  end
  resources :mail_templates
  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations"
  }
  devise_scope :user do
    post "users/guest_sign_in", to: "users/sessions#guest_sign_in", as: :guest_sign_in
  end
  resources :active_times, only: [ :index, :update ] do
    collection do
      post :update_granularity
      patch :update_all
    end
  end
  resources :events do
    collection do
      get "new/:date", to: "events#new", as: "new_with_date"
    end
  end
  get "zoom/auth",  to: "zoom#auth",  as: :zoom_auth
  get "zoom/callback",  to: "zoom#callback",  as: :zoom_callback
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"
end
