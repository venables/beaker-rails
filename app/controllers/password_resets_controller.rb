class PasswordResetsController < ApplicationController
  before_action :prevent_authenticated_user!, only: [:create]
  before_action :find_user_from_token, only: [:update]

  def create
    user = User.where(email: params[:email].try(:downcase)).first
    UserMailer.reset_password_email(user).deliver if user
    redirect_to root_url, notice: I18n.t('password_resets.create.success')
  end

  def update
    if @user.update_attributes(password_reset_params)
      redirect_to new_session_path, notice: I18n.t('password_resets.update.success')
    else
      render 'edit'
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
