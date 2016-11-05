# Preview all emails at http://localhost:3000/rails/mailers/notification_mailer
class NotificationMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/notification_mailer/new_answer_notification
  def new_answer_notification
    NotificationMailer.new_answer_notification
  end

end
