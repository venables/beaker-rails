class UserMailer < ActionMailer::Base
  default from: "from@example.com"

  def reset_password_email(user)
    @user = user
    @url = root_url + 'reset-password/' + @user.password_reset_token
    mail to: user.email
  end
end
