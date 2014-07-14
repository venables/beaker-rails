class PasswordResetsController < ApplicationController
  before_action :prevent_authenticated_user!, only: [:create]
  before_action :find_user_from_token, only: [:show, :update]

  def show
    render nothing: true, status: :ok
  end

  def create
    user = User.where(email: params[:email].try(:downcase)).first
    UserMailer.reset_password_email(user).deliver if user
    render nothing: true, status: :created
  end

  def update
    if @user.update_attributes(password_reset_params)
      render nothing: true, status: :no_content
    else
      render status: :bad_request, json: { errors: @user.errors }
    end
  end

  private

  def password_reset_params
    params.permit(:password, :password_confirmation)
  end

  def find_user_from_token
    @user = User.where(password_reset_token: params[:id]).first
    unless @user
      render status: :not_found, json: { errors: { password_reset: :not_found } }
    end
  end
end
