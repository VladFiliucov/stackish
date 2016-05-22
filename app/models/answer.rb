class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user

  validates :body, presence: true, length: { minimum: 20 }
  validates :question_id, :user_id, presence: true

  def mark_best!
    transaction do
      question.answers.update_all(best_answer?: false)
      update(best_answer?: true)
    end
  end
end
