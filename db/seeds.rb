# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Initial user
User.create!(
  name: "burak",
  email: "burak@test.com",
  password: "test12",
  password_confirmation: "test12",
  admin: true
)

# Fake users:
15.times do |i|
  name = Faker::Name.unique.name
  email = Faker::Internet.email
  password = "test12"
  User.create!(name: name, email: email, password: password, password_confirmation: password)
end

# Create fake tweets:
#99.times do |i|
#  user_id = (0..9).to_a.shuffle.join
#  tweet_id = (0..9).to_a.shuffle.join
#  screen_name = Faker::Name.name
#  name = Faker::Name.name
#  text = Faker::Lorem.sentence[0..140]
#  Tweet.create!(user_id: user_id, tweet_id: tweet_id, screen_name: screen_name, name: name, text: text, tweeted_at: Time.now)
#end
#
## Update some of the tweets as deleted
#Tweet.limit(40).each do |tweet|
#  tweet.update_attributes(deleted: true, deleted_at: Time.now)
#end
