# app/models/comment.rb
class Comment < ApplicationRecord
  belongs_to :project
  belongs_to :user

  validates :body, presence: true, if: -> { comment_type == "comment" }

  with_options if: -> { comment_type == "status_change" } do
    validates :from_status, :to_status, :reason, presence: true
  end
end
