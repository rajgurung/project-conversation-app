class Tenant < ApplicationRecord
  has_many :projects
end
