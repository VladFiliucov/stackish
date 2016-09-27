class Authorization < ActiveRecord::Base
  validates :provider, :uid, :user_id, presence: true

  belongs_to :user
end
