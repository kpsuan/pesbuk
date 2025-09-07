class User < ApplicationRecord
devise :database_authenticatable, :registerable,
:recoverable, :rememberable, :validatable


has_many :posts, dependent: :destroy
has_many :comments, dependent: :destroy
has_many :likes, dependent: :destroy


# follow relationships
has_many :active_follows, class_name: 'Follow', foreign_key: :follower_id, dependent: :destroy
has_many :passive_follows, class_name: 'Follow', foreign_key: :followed_id, dependent: :destroy
has_many :following, through: :active_follows, source: :followed
has_many :followers, through: :passive_follows, source: :follower


has_many :sent_follow_requests, class_name: 'FollowRequest', foreign_key: :requester_id, dependent: :destroy
has_many :received_follow_requests, class_name: 'FollowRequest', foreign_key: :receiver_id, dependent: :destroy


has_one_attached :avatar


validates :username, presence: true, uniqueness: { case_sensitive: false }


def avatar_url
return Rails.application.routes.url_helpers.rails_blob_url(avatar, only_path: true) if avatar.attached?
hash = Digest::MD5.hexdigest(email.to_s.strip.downcase)
"https://www.gravatar.com/avatar/#{hash}?d=identicon"
end


def feed
Post.where(user_id: [id] + following.ids).includes(:user, :likes, :comments).order(created_at: :desc)
end
end