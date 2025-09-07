class Post < ApplicationRecord
belongs_to :user
has_many :comments, dependent: :destroy
has_many :likes, dependent: :destroy


validates :content, presence: true, length: { maximum: 2000 }
has_many_attached :images
end