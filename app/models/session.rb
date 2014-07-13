class Session
  include ActiveModel::Model
  include ActiveModel::Serialization

  attr_accessor :token, :user_id
  validates :token, presence: true
  validates :user_id, presence: true

  AUTH_KEY = 'user_token'
  SESSION_SECRET = Rails.application.secrets.secret_key_base

  def self.build_for_user(user)
    session = Session.new(user_id: user.id)
    session.generate_token!(user.authentication_token)
    session
  end

  def self.decode_token(token)
    JWT.decode(token, SESSION_SECRET)[0][AUTH_KEY] rescue nil
  end

  def generate_token!(authentication_token)
    self.token = JWT.encode({ AUTH_KEY => authentication_token }, SESSION_SECRET, 'HS512')
  end
end
