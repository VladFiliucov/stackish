module QuestionsHelper
  def trigger_subscription(question)
    subscription = current_user.subscriptions.find_by(question_id: @question.id)
    if subscription
      link_to 'Unsubscribe', question_subscription_path(@question, subscription), class: 'btn btn-primary trigger_question_subscription', remote: true, method: :delete
    else
      link_to 'Subscribe', question_subscriptions_path(@question), class: 'btn btn-primary trigger_question_subscription', remote: true, method: :post
    end
  end
end
