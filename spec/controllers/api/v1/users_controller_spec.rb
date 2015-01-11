require 'rails_helper'

describe Api::V1::UsersController, type: :controller do
  let(:default_params) { { format: :json } }

  describe '#create' do
    context 'with invalid data' do
      let(:user_params) { FactoryGirl.attributes_for(:user).slice(:email) }

      it 'returns an error' do
        post :create, user: user_params

        expect(response).to render_template('error')
      end
    end

    context 'with valid data' do
      let(:user_params) { FactoryGirl.attributes_for(:user) }

      it 'creates and authenticates the user' do
        allow(controller).to receive(:sign_in)

        post :create, user: user_params

        expect(controller).to have_received(:sign_in)
        expect(response).to render_template('create')
      end
    end
  end
end
