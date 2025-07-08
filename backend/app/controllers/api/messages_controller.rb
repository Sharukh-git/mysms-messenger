class Api::MessagesController < ApplicationController
  require 'twilio-ruby'

  def index
    session_id = request.session[:session_id]
    messages = Message.where(session_id: session_id).order(created_at: :desc)
    render json: messages
  end

  def create
    session_id = request.session[:session_id] ||= SecureRandom.hex(10)
    to = params[:to]
    body = params[:body]

    begin
      client = Twilio::REST::Client.new(ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN'])

      client.messages.create(
        from: ENV['TWILIO_PHONE_NUMBER'],
        to: to,
        body: body
      )
      status = 'sent'
    rescue => e
      Rails.logger.error "Twilio Error: #{e.message}"
      status = 'failed'
    end

    message = Message.create(
      to: to,
      body: body,
      status: status,
      session_id: session_id
    )

    render json: message, status: :created
  end
end
