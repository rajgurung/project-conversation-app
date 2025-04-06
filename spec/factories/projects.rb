FactoryBot.define do
  factory :project do
    name { "Test Project" }
    status { Project::NEW } # Valid values: "New", "In Progress", "Done", "Archived"
    tenant
  end
end
