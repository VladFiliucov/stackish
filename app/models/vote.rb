class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates :user_id, :votable_id, :votable_type, presence: true
  validates_inclusion_of :rate_point, in: -1..1
end
