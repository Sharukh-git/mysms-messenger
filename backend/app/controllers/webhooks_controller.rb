class WebhooksController < ApplicationController
  
  skip_before_action :authenticate_user!, only: [:sms_status]

  def sms_status
    sid = params["MessageSid"]
    status = params["MessageStatus"]

    Rails.logger.info "Twilio webhook received - SID: #{sid}, Status: #{status}"

    message = Message.find_by(twilio_sid: sid)
    if message
      message.update(status: status)
      Rails.logger.info "Message status updated in DB"
    else
      Rails.logger.warn "Message with SID #{sid} not found"
    end

    head :ok
  end
end
