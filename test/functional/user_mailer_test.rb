require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  def test_verification_email
    user = users(:one)
    
    # Send the email, then test that it got queued
    email = UserMailer.verification_email(user).deliver
    assert !ActionMailer::Base.deliveries.empty?
    
    # Test the body of the sent email contains what we expect it to
    assert_equal [user.email], email.to
    assert_equal "Confirmation of assignment verification", email.subject
  end
end
