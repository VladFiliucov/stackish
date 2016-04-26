class Question < ActiveRecord::Base
  has_many :answers

  validates :title, presence: true
  validates :body, presence: true
  validates :title, length: { minimum: 7 }
  validates :body, length: { minimum: 10 }
end
