class Api::MessagesController < ApplicationController
  require 'twilio-ruby'

  def index
    session_id = request.session[:session_id]
    Rails.logger.info "🔍 INDEX SESSION: #{session_id}"
    messages = Message.where(session_id: session_id).order(created_at: :desc)
    render json: messages
  end

  def create
    session_id = request.session[:session_id] ||= SecureRandom.hex(10)
    Rails.logger.info "📝 CREATE SESSION: #{session_id}"
    Rails.logger.info "✅ ENV['APP_BASE_URL'] = #{ENV['APP_BASE_URL']}"
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

      status = 'sent'
      message = Message.create(
        to: to,
        body: body,
        status: status,
        session_id: session_id,
        twilio_sid: twilio_message.sid
      )

    rescue => e
      Rails.logger.error "Twilio Error: #{e.message}"
      status = 'failed'
      message = Message.create(
        to: to,
        body: body,
        status: status,
        session_id: session_id
      )
    end

    render json: message, status: :created
  end
end
