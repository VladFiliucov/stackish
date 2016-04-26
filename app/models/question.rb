class Question < ActiveRecord::Base
  validates :title, presence: true
  validates :body, presence: true
  validates_length_of :title, minimum: 7
  validates_length_of :body, minimum: 10
end
