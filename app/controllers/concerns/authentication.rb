module Authentication
  extend ActiveSupport::Concern

  AUTH_KEY = :user_token

  class NotAuthenticated < StandardError; end

  included do
    rescue_from NotAuthenticated, with: :handle_403
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
    token = session[AUTH_KEY] || cookies.signed[AUTH_KEY]
    @current_user = User.where(authentication_token: token).first if token
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
      raise NotAuthenticated.new(I18n.t('authentication.required'))
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
    redirect_to(root_path) if signed_in?
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
  def sign_in(user, remember_me=false)
    sign_out
    set_user_session(user, remember_me)
    user.update_attributes(last_login_at: Time.now.utc)
    @current_user = user
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
    reset_session
    cookies.delete(AUTH_KEY)
    @current_user = nil
  end

  # Internal: Set the "signed-in" session and cookie variables for a given
  # user, including the remember_me cookie.
  #
  # Examples
  #
  #   set_user_session(user)
  #
  # Returns nothing.
  def set_user_session(user, remember_me=false)
    cookies.permanent.signed[AUTH_KEY] = user.authentication_token if remember_me
    session[AUTH_KEY] = user.authentication_token
  end

  # Internal: Handle a '403 Unauthorized' exception. This method is called when
  # an Authentication::NotAuthenticated exception is raised.
  #
  # Examples
  #
  #   handle_403(exception)
  #   # <redirect>
  #
  # Redirects to the new session path.
  def handle_403(e)
    redirect_to new_session_path, alert: e.message
  end
end
