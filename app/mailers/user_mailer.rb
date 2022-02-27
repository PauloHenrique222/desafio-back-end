class UserMailer < ApplicationMailer
  def welcome_email(user, call_to_action)
    @call_to_action = call_to_action

    mail(subject: "Welcome to Fintera!", to: user.email)
  end
end
