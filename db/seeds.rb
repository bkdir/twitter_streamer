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

# Fake Users:
35.times do |i|
  name = Faker::Name.unique.name
  email = Faker::Internet.email
  password = "test12"
  User.create!(name: name, email: email, password: password, password_confirmation: password)
end

# Fake Twitter Users:
35.times do |i|
  user_id = (0..9).to_a.shuffle.join
  name = Faker::Name.unique.name
  screen_name = Faker::Name.unique.name
  TwitterUser.create!(screen_name: screen_name, name: name, user_id: user_id)
end

user_ids = TwitterUser.all.pluck(:user_id)

# Create fake tweets:
99.times do |i|
  user_id = user_ids[rand(0..34)]
  tweet_id = (0..9).to_a.shuffle.join
  text = Faker::Lorem.sentence[0..140]
  Tweet.create!(user_id: user_id, tweet_id: tweet_id, text: text, created_at: Time.now)
end

# Update some of the tweets as deleted
Tweet.limit(40).each do |tweet|
  tweet.update_attributes(deleted: true, deleted_at: Time.now)
end
