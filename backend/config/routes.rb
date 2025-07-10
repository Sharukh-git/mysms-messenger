Rails.application.routes.draw do
  # Devise routes for API
  devise_for :users, skip: [:sessions, :registrations], defaults: { format: :json }

  namespace :api do
    # Custom Devise controllers for API
    devise_scope :user do
      post 'signup', to: 'users/registrations#create'
      post 'login', to: 'users/sessions#create'
      delete 'logout', to: 'users/sessions#destroy'
      get 'me', to: 'users/sessions#show'
    end

    # SMS messages
    resources :messages, only: [:create, :index]
  end

  # Twilio webhook route
  post '/webhooks/sms_status', to: 'webhooks#sms_status'

  # Ping route for wake-up check
  get '/ping', to: proc { [200, {}, ['pong']] }

  # root path and prevent 404 after login redirect
  root to: proc { [200, { 'Content-Type' => 'text/plain' }, ['MySMS Messenger API']] }
end
