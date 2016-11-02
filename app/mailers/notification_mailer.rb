class NotificationMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notification_mailer.new_answer_notification.subject
  #

  def new_answer_notification(answer)
    @greeting = "Hi"
    @answer = answer
    @question = answer.question
    @subscribed_users = @question.subscriptions.map {|s| s.user }
    @email_addresses = @subscribed_users.map {|u| u.email }

    @email_addresses.each do |email|
      mail to: email
    end
  end
end
