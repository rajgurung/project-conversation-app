FactoryBot.define do
  factory :comment do
    user
    project
    comment_type { "comment" } # or "status_change"

    # for comment_type == "comment"
    body { "This is a regular comment." }

    # for comment_type == "status_change", override these in specific tests
    from_status { nil }
    to_status { nil }
    reason { nil }
  end
end
