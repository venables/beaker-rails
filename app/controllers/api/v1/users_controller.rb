class Api::V1::UsersController < Api::V1::ApplicationController
  before_filter :prevent_authenticated_user!, only: [:new, :create]

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @token = sign_in(@user)
      UserMailer.founder_email(@user).deliver_later(wait: 10.seconds)
    else
      render 'error', status: :bad_request
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
