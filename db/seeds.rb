return if Rails.env.production?

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

user = User.find_or_initialize_by(email: 'hello@superails.com')
user.password = 'hello@superails.com'
user.admin = true
user.skip_confirmation_notification!
user.confirmed_at = Time.current
user.save!

organization = Organization.find_or_create_by!(name: 'SupeRails') do |org|
  org.owner = user
end
organization.logo.attach(io: Rails.root.join('test/fixtures/files/superails-logo.png').open, filename: 'superails.png') unless organization.logo.attached?
organization.update!(privacy_setting: :public)

organization = Organization.find_or_create_by!(name: 'Avo') do |org|
  org.owner = user
end
organization.logo.attach(io: Rails.root.join('test/fixtures/files/avo-logo.png').open, filename: 'avo.png') unless organization.logo.attached?
organization.update!(privacy_setting: :restricted)

organization = Organization.find_or_create_by!(name: 'Buzzsprout') do |org|
  org.owner = user
  org.privacy_setting = :private
end
organization.logo.attach(io: Rails.root.join('test/fixtures/files/buzzsprout-logo.png').open, filename: 'buzzsprout.png') unless organization.logo.attached?

doc_admin = User.find_or_initialize_by(email: 'admin@docorg.com')
doc_admin.password = 'admin@docorg.com'
doc_admin.skip_confirmation_notification!
doc_admin.confirmed_at = Time.current
doc_admin.save!

doc_member = User.find_or_initialize_by(email: 'member@docorg.com')
doc_member.password = 'member@docorg.com'
doc_member.skip_confirmation_notification!
doc_member.confirmed_at = Time.current
doc_member.save!

doc_org = Organization.find_or_create_by!(name: 'Document Organization') do |org|
  org.owner = doc_admin
end
doc_org.memberships.find_or_create_by!(user: doc_admin) { |m| m.role = :admin }
doc_org.memberships.find_or_create_by!(user: doc_member) { |m| m.role = :member }

doc_org.projects.find_or_create_by!(name: 'Q1 Financial Report') do |p|
  p.description = 'Quarterly financial report for stakeholders'
  p.status = 'active'
  p.priority = 'high'
  p.category = 'Finance'
end

doc_org.projects.find_or_create_by!(name: 'Employee Handbook') do |p|
  p.description = 'Company policies and procedures documentation'
  p.status = 'planning'
  p.priority = 'medium'
  p.category = 'HR'
end

# if Rails.application.credentials.dig(:stripe, :private_key).present?
#   product = Stripe::Product.create(name: "Pro plan")
#   Stripe::Price.create(
#     product: product.id,
#     unit_amount: 9900,
#     currency: "usd",
#     recurring: { interval: "month" },
#   )
#   Stripe::Price.create(
#     product: product.id,
#     unit_amount: 99000,
#     currency: "usd",
#     recurring: { interval: "year" },
#   )
# end
