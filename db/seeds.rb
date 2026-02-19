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

size = company.option_types.create(name: "Size")
m = company.option_values.create(option_type: size, name: "M")
l = company.option_values.create(option_type: size, name: "L")

tshirt = company.products.create(name: "Classic Tee", description: "Best cotton ever")

# 3. Create a Specific Variant (The Medium Blue Shirt)
v1 = tshirt.variants.create(sku: "TEE-BLU-M", price: 19.99, company: company)
v1.variant_option_values.create(option_value: m, company: company)
