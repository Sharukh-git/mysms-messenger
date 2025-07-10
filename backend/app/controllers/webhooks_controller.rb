class WebhooksController < ApplicationController
  # Allow Twilio webhook to call this action without authentication
  skip_before_action :authenticate_user_unless_devise, only: [:sms_status]

  # POST /webhooks/sms_status
  # Handles status callbacks from Twilio for message delivery
  def sms_status
    sid = params["MessageSid"]
    status = params["MessageStatus"]

    Rails.logger.info "Twilio webhook received - SID: #{sid}, Status: #{status}"

    # Find and update the message status in the database
    message = Message.find_by(twilio_sid: sid)
    if message
      message.update(status: status)
      Rails.logger.info "Message status updated in DB"
    else
      Rails.logger.warn "Message with SID #{sid} not found"
    end

    # Respond with HTTP 200 OK
    head :ok
  end
end

# Note: This controller is specifically for handling Twilio SMS status updates.
