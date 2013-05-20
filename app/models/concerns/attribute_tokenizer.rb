module AttributeTokenizer
  extend ActiveSupport::Concern

  # Public: Generate a unique, random token for a given attribute.
  #
  # attr  - The user attribute that should be set to a unique token
  #
  # Examples
  #
  #   user.generate_unique_token(:authentication_token)
  #   # => "AjG3-SDWPm9x59yyuRiaTjRfxRWD-gZswXQTTVfDOyM"
  #
  #   user.generate_unique_token(:password_reset_token)
  #   # => "m_wz_K0femF4PxXVsLf3hJT0FqvfEey2aBP_u7yeVEM"
  #
  # Returns a random token that was assigned to the given attribute.
  def generate_unique_token(attr)
    begin
      self[attr] = random_token
    end while self.class.where(attr => self[attr]).exists?
  end

  # Public: Get a random token. The result may not be unique.
  #
  # Examples
  #
  #   user.random_token(:authentication_token)
  #   # => "AjG3-SDWPm9x59yyuRiaTjRfxRWD-gZswXQTTVfDOyM"
  #
  #   user.random_token(:password_reset_token)
  #   # => "m_wz_K0femF4PxXVsLf3hJT0FqvfEey2aBP_u7yeVEM"
  #
  # Returns a String containing a random token.
  def random_token
    SecureRandom.urlsafe_base64(32)
  end
end
