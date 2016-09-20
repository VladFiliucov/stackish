class Authorization < ActiveRecord::Base
  validates :provider, :uid, presence: true

  belongs_to :user
end
