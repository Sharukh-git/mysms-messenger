Rails.application.routes.draw do
  namespace :api do
    resources :messages, only: [:create, :index]
  end
  # Webhook route for Twilio SMS status updates
  post '/webhooks/sms_status', to: 'webhooks#sms_status'

end
# This file defines the routes for the API namespace, specifically for the MessagesController.
# It allows the creation of messages via a POST request to /api/messages.