class Message
  include Mongoid::Document
  include Mongoid::Timestamps

  field :to, type: String
  field :body, type: String
  field :status, type: String
  field :twilio_sid, type: String

  belongs_to :user

  validates :to, :body, presence: true
end
