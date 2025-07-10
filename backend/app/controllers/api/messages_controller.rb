class Api::MessagesController < ApplicationController
  require 'twilio-ruby'

  def index
    # Fetch messages belonging to current user, newest first
    messages = current_user.messages.order_by(created_at: :desc)
    render json: messages
  end

  def create
    to = params[:to]
    body = params[:body]

    begin
      client = Twilio::REST::Client.new(ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN'])

      twilio_message = client.messages.create(
        from: ENV['TWILIO_PHONE_NUMBER'],
        to: to,
        body: body,
        status_callback: "#{ENV['APP_BASE_URL']}/webhooks/sms_status"
      )

      message = current_user.messages.create!(
        to: to,
        body: body,
        status: 'sent',
        twilio_sid: twilio_message.sid
      )
    rescue => e
      Rails.logger.error "Twilio Error: #{e.message}"

      # Record message as failed if Twilio API call fails
      message = current_user.messages.create!(
        to: to,
        body: body,
        status: 'failed'
      )
    end

    render json: message, status: :created
  end
end
