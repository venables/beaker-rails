class UsersController < ApplicationController
  before_filter :prevent_authenticated_user!, only: [:new, :create]

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in(@user)
      UserMailer.founder_email(@user).deliver_later(wait: 10.seconds)
      redirect_to root_url, notice: I18n.t('users.create.success')
    else
      render 'new'
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
