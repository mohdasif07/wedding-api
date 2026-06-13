Rails.application.routes.draw do
  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"

  namespace :api do
    namespace :v1 do
      namespace :auth do
        post "register", to: "registrations#create"
        post "login", to: "sessions#create"
        post "logout", to: "sessions#destroy"
        post "refresh", to: "sessions#refresh"
        post "password_reset", to: "password_resets#create"
        put "password_reset", to: "password_resets#update"
      end

      resource :profile, only: %i[show update]
      resource :dashboard, only: [:show], controller: "dashboard"

      resources :events do
        resources :guests do
          member do
            post :invite, to: "invitations#create"
          end
          collection do
            post :bulk_invite, to: "invitations#bulk_create"
          end
        end
        resources :rsvps, only: %i[index]
        resources :attendances, only: %i[index]
        member do
          patch "rsvp/:guest_id", to: "rsvps#update", as: :guest_rsvp
        end
      end

      post "attendances/check_in", to: "attendances#create"

      resources :messages, only: %i[index show create]

      resources :vendors
      resources :expenses do
        collection do
          get :summary
        end
      end

      resources :albums
      resources :photos, only: %i[index show create destroy]

      resources :device_tokens, only: %i[create], param: :token do
        delete ":token", action: :destroy, on: :collection
      end

      resources :tasks, only: %i[index create update destroy]

      namespace :public do
        get "guest/:token", to: "guest_portal#show"
        patch "guest/:token/rsvp", to: "guest_portal#update_rsvp"
      end
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
