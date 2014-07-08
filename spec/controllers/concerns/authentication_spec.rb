require 'rails_helper'

class DummyController < ActionController::Base
  include Authentication
end

describe Authentication, type: :controller do
  let(:controller) { DummyController.new }
  let(:user) { FactoryGirl.build(:user) }
  let(:mock_session) { {} }
  let(:mock_request) { double('request', session: mock_session) }
  let(:mock_cookies) { double('cookies', signed: signed_cookies, permanent: permanent_cookies) }
  let(:permanent_cookies) { double('permanent', signed: signed_cookies) }
  let(:signed_cookies) { {} }
  let(:auth_key) { DummyController::AUTH_KEY }

  before do
    allow(controller).to receive_messages(cookies: mock_cookies)
    allow(controller).to receive_messages(session: mock_session)
  end

  describe '#require_authenticated_user!' do
    context 'while signed in' do
      before do
        allow(controller).to receive_messages(signed_in?: true)
      end

      it 'does not redirect' do
        allow(controller).to receive(:redirect_to)

        controller.send(:require_authenticated_user!)

        expect(controller).to_not have_received(:redirect_to)
      end
    end

    context 'while not signed in' do
      before do
        allow(controller).to receive_messages(signed_in?: false)
      end

      it 'raises a 403 error' do
        expect do
          controller.send(:require_authenticated_user!)
        end.to raise_error(DummyController::NotAuthenticated)
      end
    end
  end

  describe '#prevent_authenticated_user!' do
    let(:root_path) { '/' }

    before do
      allow(controller).to receive_messages(root_path: root_path)
    end

    context 'while signed in' do
      before do
        allow(controller).to receive_messages(signed_in?: true)
      end

      it 'redirects to the root url' do
        allow(controller).to receive(:redirect_to)

        controller.send(:prevent_authenticated_user!)

        expect(controller).to have_received(:redirect_to).with(root_path)
      end
    end

    context 'while not signed in' do
      before do
        allow(controller).to receive_messages(signed_in?: false)
      end

      it 'does nothing' do
        allow(controller).to receive(:redirect_to)

        controller.send(:prevent_authenticated_user!)

        expect(controller).to_not have_received(:redirect_to)
      end
    end
  end

  describe '#current_user' do
    let(:user) { FactoryGirl.create(:user) }

    context 'without an auth session' do
      context 'with a valid signed auth cookie' do
        let(:signed_cookies) { { user_token: user.authentication_token } }

        it 'returns the user' do
          expect(controller.current_user).to eq(user)
        end
      end

      context 'with an invalid signed auth cookie' do
        let(:signed_cookies) { { user_token: 'invalid' } }

        it 'returns nil' do
          expect(controller.current_user).to be_nil
        end
      end

      context 'without a signed auth cookie' do
        it 'returns nil' do
          expect(controller.current_user).to be_nil
        end
      end
    end

    context 'with a valid auth session' do
      let(:mock_session) { { user_token: user.authentication_token } }

      it 'returns the user' do
        expect(controller.current_user).to eq(user)
      end
    end

    context 'with an invalid auth session' do
      let(:mock_session) { { user_token: 'invalid' } }

      it 'returns nil' do
        expect(controller.current_user).to be_nil
      end
    end
  end

  describe '#signed_in?' do
    it 'returns true if a user is signed in' do
      allow(controller).to receive_messages(current_user: user)

      expect(controller.signed_in?).to be true
    end

    it 'returns false if a user is not signed in' do
      allow(controller).to receive_messages(current_user: nil)

      expect(controller.signed_in?).to be false
    end
  end

  describe '#sign_in' do
    it 'logs out and sets the current_user session' do
      allow(controller).to receive(:sign_out)
      allow(controller).to receive(:set_user_session)

      expect {
        controller.send(:sign_in, user)
      }.to change(user, :last_login_at)

      expect(controller).to have_received(:sign_out)
      expect(controller).to have_received(:set_user_session)
    end
  end

  describe '#sign_out' do
    before do
      controller.instance_variable_set(:@current_user, user)
    end

    it 'clears all traces of being signed in' do
      allow(controller).to receive(:reset_session)
      allow(mock_cookies).to receive(:delete)

      controller.send(:sign_out)

      expect(controller.current_user).to be_nil
      expect(controller).to have_received(:reset_session)
      expect(mock_cookies).to have_received(:delete).with(auth_key)
    end
  end

  describe '#set_user_session' do
    let(:user) { FactoryGirl.create(:user) }

    context 'with a remember_me flag' do
      it 'sets the session[auth_key] variable to the user id' do
        controller.send(:set_user_session, user, true)

        expect(mock_session[auth_key]).to eq(user.authentication_token)
        expect(signed_cookies[auth_key]).to eq(user.authentication_token)
      end
    end

    context 'without a remember_me flag' do
      it 'sets the session[auth_key] variable to the user id' do
        controller.send(:set_user_session, user)

        expect(mock_session[auth_key]).to eq(user.authentication_token)
      end
    end
  end

  describe '#handle_403' do
    let(:login_path) { '/sessions/new' }
    let(:error_message) { 'Please log in' }
    let(:error) { double('error', message: error_message) }

    before do
      allow(controller).to receive_messages(new_session_path: login_path)
    end

    it 'redirects to the login path' do
      allow(controller).to receive(:redirect_to)

      controller.send(:handle_403, error)

      expect(controller).to have_received(:redirect_to).with(login_path, { alert: error_message })
    end
  end
end
