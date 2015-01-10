class User < ActiveRecord::Base
  include AttributeTokenizer

  has_secure_password

  validates :email, presence: true, uniqueness: true, format: /.+\@.+\..+/
  validates :password, presence: { on: :create }, length: { minimum: 6 }

  before_save do
    generate_unique_token(:password_reset_token)
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
end
