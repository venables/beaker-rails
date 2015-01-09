class Api::V1::SessionsController < Api::V1::ApplicationController
  before_filter :prevent_authenticated_user!, only: [:create]

  def create
    if @user = User.authenticate(params[:email], params[:password])
      @token = sign_in(@user)
    else
      render 'error', status: :bad_request
    end
  end

  def destroy
    sign_out
    head :no_content
  end
end
