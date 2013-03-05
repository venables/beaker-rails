class SessionsController < ApplicationController
  before_filter :prevent_authenticated_user!, only: [:new, :create]

  def new
  end

  def create
    if user = User.authenticate(params[:email], params[:password])
      sign_in(user, !!params[:remember_me])
      redirect_to root_url, notice: I18n.t('sessions.create.success')
    else
      flash.now[:alert] = I18n.t('sessions.create.failure')
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_url, notice: I18n.t('sessions.destroy.success')
  end
end
