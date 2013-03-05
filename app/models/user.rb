class User < ActiveRecord::Base
  has_secure_password

  validates :email, presence: true, uniqueness: true, format: /.+\@.+\..+/
  validates :password, presence: true, length: { minimum: 6 }, on: :create

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
