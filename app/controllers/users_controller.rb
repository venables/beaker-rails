class UsersController < ApplicationController
  before_action :prevent_authenticated_user!, only: [:create]
  before_action :require_authenticated_user!, only: [:show]

  def show
    @user = User.find(params[:id])
    render status: :ok, json: @user

  rescue ActiveRecord::RecordNotFound
    render status: :not_found, json: { errors: { user: :not_found } }
  end

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
