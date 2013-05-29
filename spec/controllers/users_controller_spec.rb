require 'spec_helper'

describe UsersController do
  describe '#new' do
    it 'shows the signup form' do
      get :new

      expect(assigns[:user]).to be_new_record
      expect(response).to render_template('new')
    end
  end

  describe '#create' do
    context 'with invalid data' do
      let(:user_params) { FactoryGirl.attributes_for(:user).slice(:email) }

      it 'renders the new form' do
        post :create, user: user_params

        expect(response).to render_template('new')
      end
    end

    context 'with valid data' do
      let(:user_params) { FactoryGirl.attributes_for(:user) }

      it 'creates and authenticates the user' do
        controller.stub(:sign_in)

        post :create, user: user_params

        expect(controller).to have_received(:sign_in)
        expect(response).to be_redirect
      end
    end
  end
end
