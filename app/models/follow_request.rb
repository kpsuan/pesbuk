class FollowRequest < ApplicationRecord
  belongs_to :sender, class_name: "User"
  belongs_to :receiver, class_name: "User"

  # optional: validation
  validates :status, inclusion: { in: ["pending", "accepted", "declined"] }, allow_nil: true
end
