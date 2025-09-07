# db/seeds.rb
require 'faker'

# Clear old data (be careful in production!)
Like.destroy_all
Comment.destroy_all
Post.destroy_all
Follow.destroy_all
FollowRequest.destroy_all
User.destroy_all

# Create users
users = []
5.times do
  users << User.create!(
    email: Faker::Internet.unique.email,
    password: "password",
    password_confirmation: "password",
    username: Faker::Internet.username,
    name: Faker::Name.name,
    bio: Faker::Lorem.sentence
  )
end

# generate posts for user
users.each do |user|
  rand(2..4).times do
    Post.create!(
      user: user,
      content: Faker::Lorem.paragraph(sentence_count: 2)
    )
  end
end

posts = Post.all

# Add comments
posts.each do |post|
  rand(1..3).times do
    Comment.create!(
      user: users.sample,
      post: post,
      content: Faker::Lorem.sentence
    )
  end
end

# Add likes
posts.each do |post|
  users.sample(rand(1..users.size)).each do |user|
    Like.create!(user: user, post: post) unless post.likes.exists?(user: user)
  end
end

puts "Seeded #{users.count} users, #{Post.count} posts, #{Comment.count} comments, #{Like.count} likes"
