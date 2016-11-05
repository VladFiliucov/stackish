class SendNotificationsJob < ActiveJob::Base
  queue_as :default

  def perform(answer)
    @subscribed_users = answer.question.subscriptions.map {|s| s.user }

    @subscribed_users.each do |user|
      email = user.email
      NotificationMailer.new_answer_notification(answer, email).deliver_later
    end
  end
end
