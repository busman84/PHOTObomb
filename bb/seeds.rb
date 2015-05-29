require_relative './user'

# Add a test user to our database
user = User.new({ :user_name => "cookie", :email => "cookie@monster.com", :password => "cookie" })
user.hash_password
user.save
