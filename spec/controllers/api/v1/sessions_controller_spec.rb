require 'rails_helper'

describe Api::V1::SessionsController, type: :controller do
  let(:default_params) { { format: :json } }
  let(:user) { FactoryGirl.create(:user) }

  describe '#create' do
    context 'while signed in' do
      before { sign_in_user(user) }

      it 'returns an error' do
        post :create, { email: 'something', password: 'something' }

        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'with invalid credentials' do
      it 'does not sign the user in' do
        post :create, { email: 'invalid', password: 'user' }

        expect(response).to render_template('error')
        expect(response).to have_http_status(:bad_request)
        expect(current_user).to be_nil
      end
    end

    context 'with valid credentials' do
      it 'signs the user in' do
        post :create, { email: user.email, password: user.password }

        expect(response).to render_template('create')
        expect(response).to have_http_status(:created)
        expect(current_user).to eq(user)
      end
    end
  end

  describe '#destroy' do
    context 'while not signed in' do
      before { sign_out_user }

      it 'redirects to the homepage' do
        delete :destroy

        expect(response).to redirect_to(root_url)
      end
    end

    context 'while signed in' do
      before { sign_in_user(user) }

      it 'signs the user out and redirect to the homepage' do
        allow(controller).to receive(:sign_out)

        delete :destroy

        expect(controller).to have_received(:sign_out)
        expect(response).to redirect_to(root_url)
      end
    end
  end
end
