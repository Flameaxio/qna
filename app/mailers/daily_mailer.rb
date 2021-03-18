class DailyMailer < ApplicationMailer
  def digest(user)
    @questions = Question.where('created_at < ?', 1.day.ago)
    @user = user
    Rails.logger.info('sent')
    mail to: user.email
  end
end
