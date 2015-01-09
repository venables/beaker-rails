class Session
  include ActiveModel::Model
  include ActiveModel::Serialization

  AUTH_KEY = 'auth_token'
  SIGNING_KEY = Rails.application.secrets.secret_key_base
  TTL = 3_600 # 1 hour

  attr_writer :token
  attr_accessor :user

  def initialize(token, user)
    @token = token
    @user = user
  end

  def self.generate_for_user!(user)
    random_token = SecureRandom.uuid.gsub('-', '')
    session = Session.new(random_token, user)

    if session.save
      session
    end
  end

  def self.from_public_token(jwt_string)
    session_token = JWT.decode(jwt_string, SIGNING_KEY, 'HS512')[0][AUTH_KEY]
    user_id = Redis.current.get(redis_key_for_token(session_token))

    if user = User.find(user_id)
      session = Session.new(session_token, user)
      session.extend
      session
    end

  rescue
    Rails.logger.error('Session.from_public_token error')
    nil
  end

  def public_token
    JWT.encode({ AUTH_KEY => @token }, SIGNING_KEY, "HS512")
  end

  def save
    Redis.current.setex(redis_key, TTL, redis_value)
  end

  def extend
    Redis.current.expire(redis_key, TTL)
  end

  def destroy
    Redis.current.del(redis_key)
    @token = nil
    @user = nil
  end

  private

  def self.redis_key_for_token(token)
    'session:' + token
  end

  def redis_key
    Session.redis_key_for_token(@token)
  end

  def redis_value
    self.user.id
  end
end
