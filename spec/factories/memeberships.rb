FactoryBot.define do
  factory :membership do
    user
    tenant
    role { Membership::STAFF } # Valid values: "admin", "staff", "client"
  end
end
