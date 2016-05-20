class Question < ActiveRecord::Base
  has_many :answers, -> { order(best_answer?: :desc) }, dependent: :destroy
  belongs_to :user

  validates :title, :body, :user_id, presence: true
  validates :title, length: { minimum: 7 }
  validates :body, length: { minimum: 10 }
end
