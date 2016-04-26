class Answer < ActiveRecord::Base
  validates :body, presence: true
  validates_length_of :body, minimum: 20
end
