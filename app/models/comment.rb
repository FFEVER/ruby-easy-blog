class Comment < ApplicationRecord
  belongs_to :article
  belongs_to :user, optional: true
  validates :commenter, presence: true
  validates :body, presence: true, length: {minimum: 1,maximum: 500}
end
