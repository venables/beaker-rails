require 'spec_helper'

describe PasswordResetsController do

  describe "#new" do
    it "renders the reset password page" do
      get :new
      response.should render_template('new')
    end
  end

  describe "#create" do
    let(:email) { double("email", deliver: {}) }

    context "using an invalid email address" do
      it "doesn't inform the user that the email address was not found" do
        post :create, { email: 'invalid email' }
        response.should redirect_to root_url
        flash[:notice].should == I18n.t('password_resets.create.success')
      end
    end

    context "using a valid email address" do
      let(:user) { FactoryGirl.create(:user) }

      it "sends the password reset instructions to a user" do
        UserMailer.should_receive(:reset_password_email) { email }
        post :create, { email: user.email }
        response.should redirect_to root_url
        flash[:notice].should == I18n.t('password_resets.create.success')
      end
    end
  end

  describe "#edit" do
    context "with an invalid token" do
      it "redirects to the sign-in page" do
        get :edit, id: 'an invalid token'
        response.should redirect_to new_session_path
        flash[:alert].should == I18n.t('password_resets.update.failure')
      end
    end

    context "with a valid token" do
      let(:user) { FactoryGirl.create(:user) }

      it "renders the reset password page" do
        get :edit, id: user.password_reset_token
        response.should render_template('edit')
      end
    end
  end

  describe "#update" do
    context "with an invalid token" do
      it "redirects to the homepage" do
        put :update, id: 'an invalid token'
        response.should redirect_to new_session_path
        flash[:alert].should == I18n.t('password_resets.update.failure')
      end
    end

    context "with a valid token" do
      let(:user) { FactoryGirl.create(:user) }

      context "with bad passwords" do
        it "throws an error if passwords don't match" do
          put :update, id: user.password_reset_token, password: 'bad', password_confirmation: 'password'
          response.should render_template('edit')
        end

        it "throws an error if passwords aren't valid" do
          User.any_instance.should_receive(:update_attributes) { false }
          put :update, id: user.password_reset_token, password: '1', password_confirmation: '1'
          response.should render_template('edit')
        end
      end

      context "with valid passwords" do
        it "changes the user's password and redirect to the sign-in screen" do
          put :update, id: user.password_reset_token, password: 'new-password', password_confirmation: 'new-password'
          response.should redirect_to new_session_path
          flash[:notice].should == I18n.t('password_resets.update.success')
        end
      end
    end
  end

  describe "#find_user_from_token" do
    context "user not found by reset token" do
      it "redirects to the homepage" do
        get :edit, id: 'an invalid token'
        response.should redirect_to new_session_path
        flash[:alert].should == I18n.t('password_resets.update.failure')
      end
    end

    context "user found by reset token" do
      let(:user) { FactoryGirl.create(:user) }

      it "allows the request to go through" do
        get :edit, id: user.password_reset_token
        response.should_not redirect_to new_session_path
      end
    end
  end
end
