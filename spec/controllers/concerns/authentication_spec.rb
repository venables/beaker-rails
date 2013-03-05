require 'spec_helper'

class DummyController < ActionController::Base
  include Authentication
end

describe Authentication do
  let(:mock_session) { {} }
  let(:mock_request) { double("request", session: mock_session) }
  let(:mock_cookies) { double("cookies", signed: signed_cookies, permanent: permanent_cookies) }
  let(:permanent_cookies) { double("permanent", signed: signed_cookies) }
  let(:signed_cookies) { {} }
  let(:auth_key) { DummyController::AUTH_KEY }

  let(:controller) { DummyController.new }
  let(:user) { FactoryGirl.build(:user) }

  before do
    controller.stub(cookies: mock_cookies)
    controller.stub(session: mock_session)
  end

  describe "#require_authenticated_user!" do
    context 'while signed in' do
      before do
        controller.should_receive(:signed_in?) { true }
      end

      it "doesn't redirect" do
        controller.should_receive(:redirect_to).never
        controller.send(:require_authenticated_user!)
      end
    end

    context 'while not signed in' do
      before do
        controller.should_receive(:signed_in?) { false }
      end

      it 'raises a 403 error' do
        expect {
          controller.send(:require_authenticated_user!)
        }.to raise_error(DummyController::NotAuthenticated)
      end
    end
  end

  describe "#prevent_authenticated_user!" do
    context 'while signed in' do
      before do
        controller.should_receive(:signed_in?) { true }
        controller.should_receive(:root_url) { "/" }
      end

      it "redirects to the root url" do
        controller.should_receive(:redirect_to).with("/")
        controller.send(:prevent_authenticated_user!)
      end
    end

    context 'while not signed in' do
      before do
        controller.should_receive(:signed_in?) { false }
      end

      it "does nothing" do
        controller.should_receive(:redirect_to).never
        controller.send(:prevent_authenticated_user!)
      end
    end
  end

  describe "#current_user" do
    let(:user) { FactoryGirl.create(:user) }

    context "without an auth session" do
      context 'with a valid signed auth cookie' do
        let(:signed_cookies) { { user_token: user.authentication_token } }

        it "returns the user" do
          controller.send(:current_user).should == user
        end
      end

      context 'with an invalid signed auth cookie' do
        let(:signed_cookies) { { user_token: 'invalid' } }

        it "returns nil" do
          controller.send(:current_user).should be_nil
        end
      end

      context 'without a signed auth cookie' do
        it 'returns nil' do
          controller.send(:current_user).should be_nil
        end
      end
    end

    context 'with a valid auth session' do
      let(:mock_session) { { user_token: user.authentication_token } }

      it "returns the user" do
        controller.send(:current_user).should == user
      end
    end

    context "with an invalid auth session" do
      let(:mock_session) { { user_token: 'invalid' } }

      it "returns nil" do
        controller.send(:current_user).should be_nil
      end
    end
  end

  describe "#signed_in?" do
    context 'with a signed in user' do
      before do
        controller.should_receive(:current_user) { user }
      end

      it "returns true" do
        controller.send(:signed_in?).should be_true
      end
    end

    context 'without a signed in user' do
      before do
        controller.should_receive(:current_user) { nil }
      end

      it "returns false" do
        controller.send(:signed_in?).should be_false
      end
    end
  end

  describe "#sign_in" do
    it "logs out and sets the current_user session" do
      controller.should_receive(:sign_out)
      controller.should_receive(:set_user_session)
      controller.send(:sign_in, user)
    end
  end

  describe "#sign_out" do
    before do
      controller.instance_variable_set(:@current_user, user)
    end

    it "clears all traces of being signed in" do
      controller.should_receive(:reset_session)
      mock_cookies.should_receive(:delete).with(auth_key)
      controller.send(:sign_out)
      controller.instance_variable_get(:@current_user).should be_nil
    end
  end

  describe "#set_user_session" do
    let(:user) { FactoryGirl.create(:user) }

    context 'with a remember_me flag' do
      it "sets the session[auth_key] variable to the user id" do
        controller.send(:set_user_session, user, true)
        mock_session[auth_key].should == user.authentication_token
        signed_cookies[auth_key].should == user.authentication_token
      end
    end

    context 'without a remember_me flag' do
      it "sets the session[auth_key] variable to the user id" do
        controller.send(:set_user_session, user)
        mock_session[auth_key].should == user.authentication_token
      end
    end
  end

  describe '#handle_403' do
    let(:login_path) { "/sessions/new" }
    let(:error_message) { "Please log in" }
    let(:error) { double("error", message: error_message) }

    before do
      controller.should_receive(:new_session_path) { login_path }
    end

    it 'redirects to the login path' do
      controller.should_receive(:redirect_to).with(login_path, { alert: error_message })
      controller.send(:handle_403, error)
    end
  end
end
