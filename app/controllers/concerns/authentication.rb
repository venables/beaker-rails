module Authentication
  extend ActiveSupport::Concern

  AUTH_KEY = :user_token

  class NotAuthenticatedError < StandardError; end

  included do
    rescue_from NotAuthenticatedError, with: :render_unauthorized
    helper_method :current_user
    helper_method :signed_in?
  end

  # Public: The currently authenticated user.
  #
  # Examples
  #
  #   current_user
  #   # => #<User:..>
  #
  #   current_user
  #   # => nil
  #
  # Returns the User that is currently authenticated, if any.
  # Returns nil if no user is authenticated.
  def current_user
    return @current_user if @current_user
    token = user_authentication_token_from_header
    @current_user = User.where(authentication_token: token).first if token
  end

  def user_authentication_token_from_header
    user_auth_token = nil

    authenticate_with_http_token do |token, options|
      # TODO: Make this Session.decode_token or similar
      user_auth_token = JWT.decode(token, signing_key, 'HS512')[0]['auth_token']
    end

    user_auth_token
  rescue
    nil
  end

  # Public: Is there an authenticated user?
  #
  # Examples
  #
  #   signed_in?
  #   # => true
  #
  #   signed_in?
  #   # => false
  #
  # Returns true if a user is signed in, false otherwise.
  def signed_in?
    !!current_user
  end

  private

  def signing_key
    Rails.application.secrets.secret_key_base
  end

  # Internal: Require a user to be authenticated for a given action. Used as a
  # before_filter in a controller.
  #
  # Examples
  #
  #   require_authenticated_user!
  #   # => nil
  #
  #   require_authenticated_user!
  #   # !Authentication::NotAuthenticated
  #
  # Returns nil if a user is signed in.
  # Raises an Authentication::NotAuthenticated exception if there's no
  #   authenticated user.
  def require_authenticated_user!
    unless signed_in?
      raise NotAuthenticatedError
    end
  end

  # Internal: Do not allow authenticated users in the given action.
  #
  # Examples
  #
  #   prevent_authenticated_user!
  #   # => nil
  #
  #   prevent_authenticated_user!
  #   # <redirect>
  #
  # Returns nil if there's not an authenticated user.
  # Redirects to the root_path if a user is authenticated.
  def prevent_authenticated_user!
    if signed_in?
      head :forbidden
    end
  end

  # Internal: Sign in a given user by setting the session and current_user
  # variables.
  #
  # user - The user to sign in.
  #
  # Examples
  #
  #   sign_in(user)
  #   # => #<User:..>
  #
  # Returns the signed-in user.
  def sign_in(user)
    sign_out
    user.update_attributes(last_login_at: Time.now.utc)
    @current_user = user

    # TODO: Save token to redis
    token = JWT.encode({ auth_token: user.authentication_token }, signing_key, "HS512")
    token
  end

  # Internal: Sign out the currently signed-in user by resetting the session
  # and clearing all references to the user as a current_user. This method is
  # safe to call even if no user is signed in.
  #
  # Examples
  #
  #   sign_out
  #   # => nil
  #
  # Returns nil.
  def sign_out
    # TODO: Delete token from redis
    @current_user = nil
  end

  # Internal: Handle a '401 Unauthorized' exception. This method is called when
  # an Authentication::NotAuthenticatedError exception is raised.
  #
  # Responds with a JSON error
  def render_unauthorized
    self.headers['WWW-Authenticate'] = 'Token realm="Application"'
    head :unauthorized
  end
end
