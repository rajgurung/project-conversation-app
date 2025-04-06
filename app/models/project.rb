class Project < ApplicationRecord
  belongs_to :tenant
  has_many :comments

  STATUSES = [
    NEW = "New",
    IN_PROGRESS = "In Progress",
    DONE = "Done",
    ARCHIVED = "Archived"
  ]
end
