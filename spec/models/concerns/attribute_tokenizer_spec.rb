require 'spec_helper'

describe AttributeTokenizer do
  let(:user) { FactoryGirl.build(:user) }
  let(:token) { 'm_wz_K0femF4PxXVsLf3hJT0FqvfEey2aBP_u7yeVEM' }

  describe '#generate_unique_token' do
    context 'with a record with this random token' do
      let!(:existing_user) { FactoryGirl.create(:user) }

      it 'keeps generating random keys until one is found' do
        user.stub(:random_token).and_return(existing_user.authentication_token, token)

        expect {
          user.generate_unique_token(:authentication_token)
        }.to change(user, :authentication_token).to(token)
        expect(user).to have_received(:random_token).twice
      end
    end

    context 'without a record with the token already' do
      it 'assigns the unique token to the attribute specified' do
        user.stub(:random_token).and_return(token)

        expect {
          user.generate_unique_token(:authentication_token)
        }.to change(user, :authentication_token).to(token)
        expect(user).to have_received(:random_token).once
      end
    end
  end

  describe '#random_token' do
    it 'generates a url-safe token' do
      SecureRandom.stub(:urlsafe_base64) { token }

      expect(user.random_token).to eq(token)
      expect(SecureRandom).to have_received(:urlsafe_base64).with(32)
    end
  end
end
