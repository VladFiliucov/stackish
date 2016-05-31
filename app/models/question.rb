class Question < ActiveRecord::Base
  has_many :answers, -> { order(best_answer?: :desc) }, dependent: :destroy
  belongs_to :user
  has_many :attachments, as: :attachable

  validates :title, :body, :user_id, presence: true
  validates :title, length: { minimum: 7 }
  validates :body, length: { minimum: 10 }

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true
end
