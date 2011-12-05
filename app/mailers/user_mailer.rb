class UserMailer < ActionMailer::Base

  default :from => "wsma.notify@gmail.com"

  def verification_email(user)
    @user = user
    mail(:to => user.email, :subject => "Confirmation of assignment verification")
  end

  def password_reset_email(user)
    @user = user
    mail(:to => user.email, :subject => "WSMA password reset request")
  end

end
