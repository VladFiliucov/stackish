class Answer < ActiveRecord::Base
  belongs_to :question, foreign_key: 'question_id'

  validates :body, presence: true, length: { minimum: 20 }
end
