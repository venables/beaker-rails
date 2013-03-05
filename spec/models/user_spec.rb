require 'spec_helper'

describe User do
  let(:user) { FactoryGirl.build(:user) }

  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }

  describe 'email format' do
    it { should allow_value("a@b.c").for(:email) }
    it { should allow_value("mattvenables@gmail.com").for(:email) }
    it { should allow_value("mattvenables+something@b.c").for(:email) }
    it { should allow_value("user22@somewhere.mobile").for(:email) }
    it { should_not allow_value("a").for(:email) }
    it { should_not allow_value("a@b").for(:email) }
    it { should_not allow_value("asdfsadf@asdfasdf").for(:email) }
  end

  describe 'email uniqueness' do
    let(:user) { FactoryGirl.create(:user) }
    subject { user }
    it { should validate_uniqueness_of(:email) }
  end

  describe '.authenticate' do
    context 'with an unknown email address' do
      it 'returns nil' do
        User.authenticate('unknown', user.password).should be_nil
      end
    end

    context 'with a known email address' do
      let(:user) { FactoryGirl.create(:user) }

      context 'with an invalid password' do
        it 'returns nil' do
          User.authenticate(user.email, 'invalid').should be_false
        end
      end

      context 'with a valid password' do
        it 'returns the User' do
          User.authenticate(user.email, user.password).should == user
        end
      end
    end
  end

  describe '#email=' do
    context 'given a nil value' do
      it 'sets :email to nil' do
        user.email.should_not be_nil
        user.email = nil
        user.email.should be_nil
      end
    end

    context 'given a String value' do
      let(:address) { "MATTVenables@Gmail.Com" }

      it 'sets :email to the lowercase version of the string' do
        user.email.should_not == address.downcase
        user.email = address
        user.email.should == address.downcase
      end
    end
  end

  describe '#generate_token' do
    let(:token) { "m_wz_K0femF4PxXVsLf3hJT0FqvfEey2aBP_u7yeVEM" }

    context 'with a user with this random token' do
      let!(:existing_user) { FactoryGirl.create(:user) }

      it 'keeps generating random keys until one is found' do
        SecureRandom.should_receive(:urlsafe_base64).exactly(2).times.and_return(existing_user.authentication_token, token)
        expect {
          user.generate_token(:authentication_token)
        }.to change(user, :authentication_token).to(token)
      end
    end

    context 'without a user with the token already' do
      it 'assigns the unique token to the attribute specified' do
        SecureRandom.should_receive(:urlsafe_base64).once.and_return(token)
        expect {
          user.generate_token(:authentication_token)
        }.to change(user, :authentication_token).to(token)
      end
    end
  end
end
