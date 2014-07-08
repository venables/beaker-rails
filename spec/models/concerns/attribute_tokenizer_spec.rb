require 'rails_helper'

describe AttributeTokenizer, type: :model do
  let(:user) { FactoryGirl.build(:user) }
  let(:token) { 'm_wz_K0femF4PxXVsLf3hJT0FqvfEey2aBP_u7yeVEM' }

  describe '#generate_unique_token' do
    context 'with an existing record with this token' do
      let!(:existing_user) { FactoryGirl.create(:user) }

      it 'keeps generating UUIDs until one is unique' do
        allow(user).to receive(:unique_token).and_return(existing_user.authentication_token, token)

        expect {
          user.generate_unique_token(:authentication_token)
        }.to change(user, :authentication_token).to(token)
        expect(user).to have_received(:unique_token).twice
      end
    end

    context 'without an existing record with the token already' do
      it 'assigns the unique token to the attribute specified' do
        allow(user).to receive(:unique_token).and_return(token)

        expect {
          user.generate_unique_token(:authentication_token)
        }.to change(user, :authentication_token).to(token)
        expect(user).to have_received(:unique_token).once
      end
    end
  end

  describe '#generate_random_token' do
    it 'assigns the random, non-unique token to the attribute specified' do
      allow(user).to receive(:random_token).and_return(token)

      expect {
        user.generate_random_token(:authentication_token)
      }.to change(user, :authentication_token).to(token)
      expect(user).to have_received(:random_token).once
    end
  end

  describe '#random_token' do
    it 'generates a unique token' do
      allow(SecureRandom).to receive(:uuid) { token }

      expect(user.unique_token).to eq(token)
      expect(SecureRandom).to have_received(:uuid)
    end
  end

  describe '#random_token' do
    it 'generates a url-safe token' do
      allow(SecureRandom).to receive(:urlsafe_base64) { token }

      expect(user.random_token).to eq(token)
      expect(SecureRandom).to have_received(:urlsafe_base64).with(32)
    end
  end
end
