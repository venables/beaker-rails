class User < ActiveRecord::Base
  has_secure_password

  validates :email, presence: true, uniqueness: true, format: /.+\@.+\..+/
  validates :password, presence: true, length: { minimum: 6 }, on: :create

  before_create do
    generate_token(:authentication_token)
  end

  # Public: Authenticate a user with a given email and password.
  #
  # email     - A String containing the authenticating User's email.
  # password  - A String containing the password to use for authentication.
  #
  # Examples
  #
  #   User.authenticate('unknown@email.com', nil)
  #   # => nil
  #
  #   User.authenticate('valid@email.com', 'invalid')
  #   # => false
  #
  #   User.authenticate('valid@email.com', 'valid')
  #   # => #<User:..>
  #
  # Returns the User record if valid credentials are provided.
  # Returns false if the password is invalid for the given email address.
  # Returns nil if the email address was not found in the database.
  def self.authenticate(email, password)
    user = where(email: email.try(:downcase)).first
    user.try(:authenticate, password)
  end

  # Public: Set the user's email address, forcing it to lowercase.
  #
  # new_email - The email address to use
  #
  # Examples
  #   user.email = 'MATTVENABLES@gmail.com'
  #   # => "mattvenables@gmail.com"
  #
  # Returns the email address that was written to the model.
  def email=(new_email)
    write_attribute :email, new_email.try(:downcase)
  end

  # Public: Generate a unique, random token for a given attribute
  #
  # attr  - The user attribute that should be set to a unique token
  #
  # Examples
  #
  #   user.generate_token(:authentication_token)
  #   # => "AjG3-SDWPm9x59yyuRiaTjRfxRWD-gZswXQTTVfDOyM"
  #
  #   user.generate_token(:password_reset_token)
  #   # => "m_wz_K0femF4PxXVsLf3hJT0FqvfEey2aBP_u7yeVEM"
  #
  # Returns a random token that was assigned to the given attribute.
  def generate_token(attr)
    begin
      self[attr] = SecureRandom.urlsafe_base64(32)
    end while User.where(attr => self[attr]).exists?
  end
end
