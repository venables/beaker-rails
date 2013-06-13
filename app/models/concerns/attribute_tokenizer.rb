module AttributeTokenizer
  extend ActiveSupport::Concern

  # Public: Generate a unique token for a given attribute.
  #
  # attr - The attribute that should be set to a unique token
  #
  # Examples
  #
  #   user.generate_unique_token(:authentication_token)
  #   # => "f83f4221d3ac477398bc804bdb7149fc"
  #
  #   user.generate_unique_token(:password_reset_token)
  #   # => "cc56d0ce7a2f459ab963926592eb67f6"
  #
  # Returns a unique token that was assigned to the given attribute.
  def generate_unique_token(attr)
    begin
      self[attr] = unique_token
    end while self.class.where(attr => self[attr]).exists?
  end

  # Public: Generate a random, non-unique token for a given attribute.
  #
  # attr - The attribute that should be set to a random token
  #
  # Examples
  #
  #   user.generate_random_token(:authentication_token)
  #   # => "AjG3-SDWPm9x59yyuRiaTjRfxRWD-gZswXQTTVfDOyM"
  #
  #   user.generate_random_token(:password_reset_token)
  #   # => "m_wz_K0femF4PxXVsLf3hJT0FqvfEey2aBP_u7yeVEM"
  #
  # Returns a random token that was assigned to the given attribute.
  def generate_random_token(attr)
    self[attr] = random_token
  end

  # Public: Get a v4 UUID to be used as a unique token.
  #
  # Examples
  #
  #   user.unique_token
  #   # => "f83f4221d3ac477398bc804bdb7149fc"
  #
  #   user.unique_token
  #   # => "cc56d0ce7a2f459ab963926592eb67f6"
  #
  # Returns a String containing a random token.
  def unique_token
    SecureRandom.uuid.gsub('-', '')
  end

  # Public: Get a random token. The result may not be unique.
  #
  # Examples
  #
  #   user.random_token
  #   # => "AjG3-SDWPm9x59yyuRiaTjRfxRWD-gZswXQTTVfDOyM"
  #
  #   user.random_token
  #   # => "m_wz_K0femF4PxXVsLf3hJT0FqvfEey2aBP_u7yeVEM"
  #
  # Returns a String containing a random token.
  def random_token
    SecureRandom.urlsafe_base64(32)
  end
end
