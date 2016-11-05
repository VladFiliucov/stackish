class NotificationMailer < ApplicationMailer

  def new_answer_notification(answer, email)
    @greeting = "Hi"
    @answer = answer
    @question = answer.question

    mail :to => email
  end
end
