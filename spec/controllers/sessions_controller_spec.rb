require 'spec_helper'

describe SessionsController do
  let(:user) { FactoryGirl.create(:user) }

  describe '#new' do
    context 'while signed in' do
      before { sign_in_user(user) }

      it 'redirects to the root url' do
        get :new

        expect(response).to redirect_to(root_url)
      end
    end

    context 'while not signed in' do
      before { sign_out_user }

      it 'renders the new page' do
        get :new

        expect(response).to render_template('new')
      end
    end
  end

  describe '#create' do
    context 'while signed in' do
      before { sign_in_user(user) }

      it 'redirects to the root url' do
        post :create, { email: 'something', password: 'something' }

        expect(response).to redirect_to(root_url)
      end
    end

    context 'with invalid credentials' do
      it 'does not sign the user in' do
        post :create, { email: 'invalid', password: 'user' }

        expect(response).to render_template('new')
        expect(current_user).to be_nil
      end
    end

    context 'with valid credentials' do
      it 'signs the user in' do
        post :create, { email: user.email, password: user.password }

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
        controller.stub(:sign_out)

        delete :destroy

        expect(controller).to have_received(:sign_out)
        expect(response).to redirect_to(root_url)
      end
    end
  end
end
