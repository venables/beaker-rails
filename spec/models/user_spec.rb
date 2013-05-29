require 'spec_helper'

describe User do
  let(:user) { FactoryGirl.build(:user) }

  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }

  it 'validates email format' do
    expect(user).to allow_value('a@b.c').for(:email)
    expect(user).to allow_value('mattvenables@gmail.com').for(:email)
    expect(user).to allow_value('mattvenables+something@b.c').for(:email)
    expect(user).to allow_value('user22@somewhere.mobile').for(:email)
    expect(user).to_not allow_value('a').for(:email)
    expect(user).to_not allow_value('a@b').for(:email)
    expect(user).to_not allow_value('asdfsadf@asdfasdf').for(:email)
  end

  it 'ensures email uniqueness' do
    user = FactoryGirl.create(:user)

    expect(user).to validate_uniqueness_of(:email)
  end

  describe '.authenticate' do
    context 'with an unknown email address' do
      it 'returns nil' do
        expect(User.authenticate('unknown', user.password)).to be_nil
      end
    end

    context 'with a known email address' do
      let(:user) { FactoryGirl.create(:user) }

      context 'with an invalid password' do
        it 'returns nil' do
          expect(User.authenticate(user.email, 'invalid')).to be_false
        end
      end

      context 'with a valid password' do
        it 'returns the User' do
          expect(User.authenticate(user.email, user.password)).to eq(user)
        end
      end
    end
  end

  describe '#email=' do
    context 'given a nil value' do
      it 'sets :email to nil' do
        expect { user.email = nil }.to change(user, :email).to(nil)
      end
    end

    context 'given a String value' do
      let(:address) { 'MATTVENABLES@GMAIL.COM' }

      it 'sets :email to the lowercase version of the string' do
        expect {
          user.email = address
        }.to change(user, :email).to(address.downcase)
      end
    end
  end
end
