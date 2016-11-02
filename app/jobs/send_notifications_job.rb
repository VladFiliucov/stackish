class SendNotificationsJob < ActiveJob::Base
  queue_as :default

  def perform(answer)
    NotificationMailer.new_answer_notification(answer).deliver_later
  end
end
