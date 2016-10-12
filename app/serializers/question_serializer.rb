class QuestionSerializer < ActiveModel::Serializer
  self.root = true
  attributes :id, :title, :body, :created_at, :updated_at
  has_many :answers
  has_many :attachable
end
