class User
  include Mongoid::Document
  include Mongoid::Timestamps

  # Devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  ## Database authenticatable
  field :email,              type: String, default: ""
  field :encrypted_password, type: String, default: ""

  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  has_many :messages

  # Normalize email before validation
  before_validation :normalize_email

  
  index({ email: 1 }, { unique: true, collation: { locale: 'en', strength: 2 } })

  private

  def normalize_email
    self.email = email.to_s.strip.downcase
  end
end
