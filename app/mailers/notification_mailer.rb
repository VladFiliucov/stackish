class NotificationMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notification_mailer.new_answer_notification.subject
  #
  def notify_users(requestor, user)
    [requestor, user].each{ |u| notify_user(requestor, u) }
  end

  def notify_user(requestor, user)
    @requestor = requestor
    @user = user
    mail :to => user.email, :subject => "User requested update"
  end

  def new_answer_notification(answer)
    set_user_attrs(answer)

    @email_addresses.each do |email|
      mail :to => email
    end
  end

  def set_user_attrs(answer)
    @greeting = "Hi"
    @answer = answer
    @question = answer.question
    @subscribed_users = @question.subscriptions.map {|s| s.user }
    @email_addresses = @subscribed_users.map {|u| u.email }
  end
end
