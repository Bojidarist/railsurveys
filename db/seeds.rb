# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Create admin user with random password (change it with 'forgot password')
randomPassword = Devise.friendly_token.first(8)
user = User.new(
  email: "admin@railsurveys.com", username: "adminuser",
  password: randomPassword, password_confirmation: randomPassword,
  role: "admin"
).save!
