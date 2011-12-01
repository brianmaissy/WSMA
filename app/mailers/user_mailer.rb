class UserMailer < ActionMailer::Base
  default :from => "from@example.com"
  
  def verification_email(user)
    @user = user
    mail(:to => user.email, :subject => "Confirmation of assignment verification")
  end
end
