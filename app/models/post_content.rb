class PostContent < ApplicationRecord
  belongs_to :postable, polymorphic: true
end
