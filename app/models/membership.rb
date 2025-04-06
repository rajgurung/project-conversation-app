class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :tenant

  ROLES = [
    ADMIN = 'admin',
    STAFF = 'staff',
    CLIENT = 'client'
  ].freeze # This could actually be a ENUM and would gives us methods out of the box like admin?, staff?, client?
end
