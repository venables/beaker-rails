require 'spec_helper'

describe AttributeTokenizer do
  let(:user) { FactoryGirl.build(:user) }
  let(:token) { "m_wz_K0femF4PxXVsLf3hJT0FqvfEey2aBP_u7yeVEM" }

  describe '#generate_unique_token' do
    context 'with a record with this random token' do
      let!(:existing_user) { FactoryGirl.create(:user) }

      it 'keeps generating random keys until one is found' do
        user.should_receive(:random_token).exactly(2).times.
          and_return(existing_user.authentication_token, token)

        expect {
          user.generate_unique_token(:authentication_token)
        }.to change(user, :authentication_token).to(token)
      end
    end

    context 'without a record with the token already' do
      it 'assigns the unique token to the attribute specified' do
        user.should_receive(:random_token).once.and_return(token)
        expect {
          user.generate_unique_token(:authentication_token)
        }.to change(user, :authentication_token).to(token)
      end
    end
  end

  describe '#random_token' do
    it 'generates a url-safe token' do
      SecureRandom.should_receive(:urlsafe_base64).with(32) { token }
      user.random_token.should == token
    end
  end
end
