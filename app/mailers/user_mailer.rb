class UserMailer < ApplicationMailer
  default from: 'no-reply@francast.com'

  def welcome_email(user)
    @user = user
    @url  = 'http://localhost:3000/users/sign_in'
    mail(to: @user.email, subject: 'Welcome to Pesbuk!')
  end
end
