class UsersController < ApplicationController
  before_filter :prevent_authenticated_user!, only: [:new, :create]

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in(@user)
      render status: :created, json: @user
    else
      render status: :bad_request, json: { errors: @user.errors }
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
