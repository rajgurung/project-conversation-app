# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

puts "Seeding data for #{Rails.env} environment..."

# return p 'Exiting ... its a prod env' if Rails.env == 'production'

puts "Seeding development data..."

# Fetch passwords from ENV and validate presence
staff_password = ENV["STAFF_USER_PASSWORD"] || "Pass1234"
client_password = ENV["CLIENT_USER_PASSWORD"] || "Pass1234"

raise "STAFF_USER_PASSWORD is not set!" if staff_password.blank?
raise "CLIENT_USER_PASSWORD is not set!" if client_password.blank?

# Create tenant
tenant = Tenant.find_or_create_by!(name: "Acme Corp")

# Internal Admin Staff
staff = User.find_or_create_by!(email: "admin@staff.com") do |user|
  user.name = "James Ryan"
  user.password = staff_password
end
Membership.find_or_create_by!(user: staff, tenant: tenant, role: Membership::ADMIN)

# Internal Staff
staff = User.find_or_create_by!(email: "staff@staff.com") do |user|
  user.name = "Phil Smith"
  user.password = staff_password
end
Membership.find_or_create_by!(user: staff, tenant: tenant, role: Membership::STAFF)

# External Client
client = User.find_or_create_by!(email: "client@acme.com") do |user|
  user.name = "External Client"
  user.password = client_password
end
Membership.find_or_create_by!(user: client, tenant: tenant, role: Membership::CLIENT)

# Project
Project.find_or_create_by!(name: "Website Redesign", tenant: tenant) do |project|
  project.status = "New"
end

#################################################################################

# Setup Another Client
tenant = Tenant.find_or_create_by!(name: "Another Corp")

# Internal Staff
staff = User.find_or_create_by!(email: "admin@staff.com") do |user|
  user.name = "James Ryan"
  user.password = staff_password
end
Membership.find_or_create_by!(user: staff, tenant: tenant, role: Membership::ADMIN)

# Project
Project.find_or_create_by!(name: "Logo Design", tenant: tenant) do |project|
  project.status = "New"
end

puts "✅ Seed complete: users, tenant, and project created."
