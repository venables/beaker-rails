require "spec_helper"

describe UserMailer do
  include EmailSpec::Helpers
  include EmailSpec::Matchers

  describe ".reset_password_email" do
    let(:user) { FactoryGirl.create(:user) }
    subject { UserMailer.reset_password_email(user) }

    it { should deliver_to(user.email) }
    it { should have_subject(I18n.t('user_mailer.reset_password_email.subject')) }
    it { should have_body_text(I18n.t('user_mailer.reset_password_email.intro')) }
    it { should have_body_text(/#{edit_password_reset_url(user.password_reset_token)}/) }
  end
end
