class Api::V1::PasswordResetsController < Api::V1::ApplicationController
  before_filter :prevent_authenticated_user!, only: [:create]
  before_filter :find_user_from_token, only: [:update]

  def create
    user = User.where(email: params[:email].try(:downcase)).first
    UserMailer.reset_password_email(user).deliver_later if user
    head :created
  end

  def update
    if @user.update_attributes(password_reset_params)
      head :no_content
    else
      render 'error', status: :bad_request
    end
  end

  private

  def password_reset_params
    params.permit(:password, :password_confirmation)
  end

  def find_user_from_token
    @user = User.where(password_reset_token: params[:id]).first
    unless @user
      redirect_to new_session_path, alert: I18n.t('password_resets.update.failure')
    end
  end
end
