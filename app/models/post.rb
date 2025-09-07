class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  has_many_attached :images  # allow multiple images if needed

  validates :content, length: { maximum: 2000 }, allow_blank: true
  validate :must_have_text_or_image

  private

  def must_have_text_or_image
    if content.blank? && images.blank?
      errors.add(:base, "Post must have text or at least one image")
    end
  end
end
