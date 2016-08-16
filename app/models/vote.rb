class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates :user_id,  presence: true
  validates :rate_point, inclusion: { in: -1..1 }
end
