class UpdatesMailer < ApplicationMailer
  def notify(user, question)
    @question = question
    @user = user
    mail to: user.email
  end
end
