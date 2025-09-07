class User < ApplicationRecord
  # Devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Associations
  has_one_attached :avatar
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  # Follow relationships
  has_many :active_follows, class_name: 'Follow', foreign_key: :follower_id, dependent: :destroy
  has_many :passive_follows, class_name: 'Follow', foreign_key: :followed_id, dependent: :destroy
  has_many :following, through: :active_follows, source: :followed
  has_many :followers, through: :passive_follows, source: :follower

  # Follow requests
  has_many :sent_follow_requests, class_name: 'FollowRequest', foreign_key: :sender_id, dependent: :destroy
  has_many :received_follow_requests, class_name: 'FollowRequest', foreign_key: :receiver_id, dependent: :destroy

  # Validations
  validates :username, presence: true, uniqueness: { case_sensitive: false }

  # Callbacks
  after_create :send_welcome_email

  # -------------------------
  # Avatar methods
  # -------------------------
  # Returns the avatar URL, uses Gravatar as fallback
  def avatar_url(size: 200)
    if avatar.attached?
      Rails.application.routes.url_helpers.rails_representation_url(
        avatar.variant(resize_to_limit: [size, size]).processed,
        only_path: true
      )
    else
      hash = Digest::MD5.hexdigest(email.to_s.strip.downcase)
      "https://www.gravatar.com/avatar/#{hash}?d=identicon&s=#{size}"
    end
  end

  # Returns an ActiveStorage variant for a specific size
  def avatar_variant(resize_to:)
    return unless avatar.attached?

    avatar.variant(resize_to_limit: resize_to).processed
  end

  # -------------------------
  # Feed
  # -------------------------
  # Returns posts from the user and their following, newest first
  def feed
    Post.where(user_id: [id] + following.ids)
        .includes(:user, :likes, :comments)
        .order(created_at: :desc)
  end

  private

  # Sends a welcome email after user creation
  def send_welcome_email
    UserMailer.welcome_email(self).deliver_later
  end
end
