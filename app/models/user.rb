class User < ApplicationRecord
  has_many :memberships
  has_many :tenants, through: :memberships

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


  # A user can belong to many tenants.
  # Their role (admin / staff / client) can be different per tenant
  # The role is stored in the memberships table.
  def role_for(tenant)
    memberships.find_by(tenant: tenant)&.role
  end
end
