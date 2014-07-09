class SessionsController < ApplicationController
  before_filter :prevent_authenticated_user!, only: [:create]

  def create
    if user = User.authenticate(params[:email], params[:password])
      sign_in(user, !!params[:remember_me])
      render status: :created, json: { session_token: 'abc123' }
    else
      render status: :bad_request, json: { password: :invalid }
    end
  end

  def destroy
    sign_out
    render status: :no_content
  end
end
