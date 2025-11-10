# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
AdminUser.create!(email: 'daniel@gmail.com', password: '123456789', password_confirmation: '123456789') if Rails.env.development?

company = Company.find_or_create_by!(
  name: 'remax-scotland',
  email: '',
  phone: '0131 278 0508',
  ai_source: 'openai'
)

company.users.create!(
  email: 'darenas@gmail.com',
  password: '123456789',
)
