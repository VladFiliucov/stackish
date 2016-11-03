class Question < ActiveRecord::Base
  include Votable
  include Commentable

  has_many :answers, -> { order(best_answer?: :desc) }, dependent: :destroy
  belongs_to :user
  has_many :subscriptions, dependent: :destroy
  has_many :attachments, as: :attachable

  validates :title, :body, :user_id, presence: true
  validates :title, length: { minimum: 7 }
  validates :body, length: { minimum: 10 }

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  after_create :update_reputation
  after_create :subscribe_author_for_updates

  scope :posted_today, -> { where('created_at >= ?', Time.zone.now.beginning_of_day) }

  private

  def subscribe_author_for_updates
    self.user.subscriptions.create!(question_id: self.id)
  end

  def update_reputation
    CalculateReputationJob.perform_later(self)
  end
end
