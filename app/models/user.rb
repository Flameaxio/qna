class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable,
         :omniauthable, omniauth_providers: %i[github twitter]
  has_many :questions
  has_many :answers
  has_many :comments
  has_many :user_opinions, dependent: :delete_all
  has_many :authorizations, dependent: :delete_all
  has_many :subscriptions, dependent: :delete_all

  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth[:provider], uid: auth[:uid].to_s).first
    return authorization.user if authorization

    email = auth[:info][:email]

    provider = auth[:provider]
    uid = auth[:uid].to_s

    user = User.where(email: email).first
    return nil unless user

    user.create_authorization(auth)

    user
  end

  def create_authorization(auth)
    authorizations.create(provider: auth.provider, uid: auth.uid)
  end
end
