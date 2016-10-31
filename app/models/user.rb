class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook, :twitter]
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :votes, as: :votable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :authorizations, dependent: :destroy

  scope :all_except_current, ->(user) { where.not(email: user.email) }

  def author?(object)
    self.id == object.user_id
  end

  def self.send_daily_digest
    find_each.each do |user|
      DailyMailer.digest(user).deliver_now
    end
  end

  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth[:provider], uid: auth[:uid].to_s).first
    return authorization.user if authorization

    email = auth.info[:email]

    user = User.where(email: email).first
    if user
      user.create_authorization(auth)
    else
      password = Devise.friendly_token[0, 20]
      user = User.new(email: email, password: password, password_confirmation: password)
      if user.save
        user.create_authorization(auth)
      else
        return User.new
      end
    end
    user
  end

  def create_authorization(auth)
    self.authorizations.create(provider: auth.provider, uid: auth.uid)
  end
end
