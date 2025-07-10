class Api::MessagesController < ApplicationController
  require 'twilio-ruby'

  # GET /api/messages
  def index
    # Fetch messages belonging to the current user, newest first
    messages = current_user.messages.order_by(created_at: :desc)
    render json: messages
  end

  # POST /api/messages
  def create
    to = params[:to]
    body = params[:body]

    begin
      # Initialize Twilio client
      client = Twilio::REST::Client.new(ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN'])

      # Send SMS via Twilio with status callback
      twilio_message = client.messages.create(
        from: ENV['TWILIO_PHONE_NUMBER'],
        to: to,
        body: body,
        status_callback: "#{ENV['APP_BASE_URL']}/webhooks/sms_status"
      )

      # Save message to DB with 'sent' status and Twilio SID
      message = current_user.messages.create!(
        to: to,
        body: body,
        status: 'sent',
        twilio_sid: twilio_message.sid
      )

    rescue => e
      Rails.logger.error "Twilio Error: #{e.message}"

      # Save message with 'failed' status if Twilio call fails
      message = current_user.messages.create!(
        to: to,
        body: body,
        status: 'failed'
      )
    end

    render json: message, status: :created
  end
end
