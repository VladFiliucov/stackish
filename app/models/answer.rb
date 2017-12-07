class Answer < ActiveRecord::Base
  include Votable
  include Commentable

  belongs_to :question, touch: true
  belongs_to :user
  has_many :attachments, as: :attachable

  validates :body, presence: true, length: { minimum: 20 }
  validates :question_id, :user_id, presence: true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  after_create :update_reputation, on: :create
  after_create :notify_subscribers, on: :create

  searchkick

  def mark_best!
    transaction do
      question.answers.update_all(best_answer?: false)
      update(best_answer?: true)
    end
  end

  private

  def notify_subscribers
    SendNotificationsJob.perform_later(self)
  end

  def update_reputation
    CalculateReputationJob.perform_later(self)
  end
end
