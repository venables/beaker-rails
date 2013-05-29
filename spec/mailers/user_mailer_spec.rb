require 'spec_helper'

describe UserMailer do
  include EmailSpec::Helpers
  include EmailSpec::Matchers

  describe '.reset_password_email' do
    let(:user) { FactoryGirl.create(:user) }

    it 'delivers the correct email' do
      mail = UserMailer.reset_password_email(user)

      expect(mail).to deliver_to(user.email)
      expect(mail).to have_subject(I18n.t('user_mailer.reset_password_email.subject'))
      expect(mail).to have_body_text(I18n.t('user_mailer.reset_password_email.intro'))
      expect(mail).to have_body_text(/#{edit_password_reset_url(user.password_reset_token)}/)
    end

  end
end
