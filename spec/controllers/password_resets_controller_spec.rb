require 'rails_helper'

describe PasswordResetsController, type: :controller do
  describe '#new' do
    it 'renders the reset password page' do
      get :new

      expect(response).to render_template('new')
    end
  end

  describe '#create' do
    let(:email) { double('email', deliver: {}) }

    context 'using an invalid email address' do
      it 'does not inform the user that the email address was not found' do
        post :create, { email: 'invalid email' }

        expect(response).to redirect_to(root_url)
        expect(flash[:notice]).to eq(I18n.t('password_resets.create.success'))
      end
    end

    context 'using a valid email address' do
      let(:user) { FactoryGirl.create(:user) }

      it 'sends the password reset instructions to a user' do
        email = double('email', deliver_later: true)
        allow(UserMailer).to receive(:reset_password_email).and_return(email)

        post :create, { email: user.email }

        expect(UserMailer).to have_received(:reset_password_email)
        expect(email).to have_received(:deliver_later)
        expect(response).to redirect_to(root_url)
        expect(flash[:notice]).to eq(I18n.t('password_resets.create.success'))
      end
    end
  end

  describe '#edit' do
    context 'with an invalid token' do
      it 'redirects to the sign-in page' do
        get :edit, id: 'an invalid token'

        expect(response).to redirect_to(new_session_path)
        expect(flash[:alert]).to eq(I18n.t('password_resets.update.failure'))
      end
    end

    context 'with a valid token' do
      let(:user) { FactoryGirl.create(:user) }

      it 'renders the reset password page' do
        get :edit, id: user.password_reset_token

        expect(response).to render_template('edit')
      end
    end
  end

  describe '#update' do
    context 'with an invalid token' do
      it 'redirects to the homepage' do
        put :update, id: 'an invalid token'

        expect(response).to redirect_to(new_session_path)
        expect(flash[:alert]).to eq(I18n.t('password_resets.update.failure'))
      end
    end

    context 'with a valid token' do
      let(:user) { FactoryGirl.create(:user) }

      context 'with bad passwords' do
        it 'throws an error if passwords do not match' do
          put :update, id: user.password_reset_token, password: 'bad', password_confirmation: 'password'

          expect(response).to render_template('edit')
        end

        it 'throws an error if passwords are not valid' do
          allow_any_instance_of(User).to receive_messages(update_attributes: false)

          put :update, id: user.password_reset_token, password: '1', password_confirmation: '1'

          expect(response).to render_template('edit')
        end
      end

      context 'with valid passwords' do
        it 'changes the password and redirect to the sign-in screen' do
          put :update, id: user.password_reset_token, password: 'new-password', password_confirmation: 'new-password'

          expect(response).to redirect_to(new_session_path)
          expect(flash[:notice]).to eq(I18n.t('password_resets.update.success'))
        end
      end
    end
  end

  describe '#find_user_from_token' do
    context 'user not found by reset token' do
      it 'redirects to the homepage' do
        get :edit, id: 'an invalid token'

        expect(response).to redirect_to(new_session_path)
        expect(flash[:alert]).to eq(I18n.t('password_resets.update.failure'))
      end
    end

    context 'user found by reset token' do
      let(:user) { FactoryGirl.create(:user) }

      it 'allows the request to go through' do
        get :edit, id: user.password_reset_token

        expect(response).to_not redirect_to(new_session_path)
      end
    end
  end
end
