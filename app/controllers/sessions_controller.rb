class SessionsController < ApplicationController
  before_action :prevent_authenticated_user!, only: [:create]

  def create
    if user = User.authenticate(params[:email], params[:password])
      token = sign_in(user, !!params[:remember_me])
      render status: :created, json: { session_token: token }
    else
      render status: :bad_request, json: { password: :invalid }
    end
  end

  def destroy
    sign_out
    render status: :no_content
  end
end
