require 'sinatra'
require 'sinatra/reloader'

# Include the user model 
require_relative './user'

# Sessions are turned off by default, so enable it here
# We use sessions in our app to keep track of authenticated users. If we didn't 
# use sessions, the same user would have to log back in with every request to 
# a new page
enable :sessions

# Filter that runs before all routes are processed
# This is run first, then the code within the routes below
before do 
	# If they have a session id, we know it's someone who has successfully authenticated
	if session[:user_id] != nil
		# If there's a user with an active session, go ahead and get the data for the user
		ActiveRecord::Base.establish_connection(
	:adapter => 'postgresql',
	:host => 'localhost',
	:database => 'photo'
)
		@current_user = User.find(session[:user_id])
		ActiveRecord::Base.connection.close
	else 
		# We don't know who this is yet
		@current_user = nil
	end
end 
# after do
#   ActiveRecord::Base.connection.close
# end

# Homepage route
get '/' do
	# If @current_user is not set, that means they are not allowed to access this resource
	if @current_user != nil
		erb :index
	else 
		# Lead them to the login page
		redirect('/login')
	end
end

# Display login form
get '/login' do 
	erb :login
end

# Check if login form contents posted is valid
post '/login' do 
	# Get form params
	user_name = params['user_name']
	password = params['password']

	# Get an instance of the user with this username 
	ActiveRecord::Base.establish_connection(
	:adapter => 'postgresql',
	:host => 'localhost',
	:database => 'photo'
)
	user = User.find_by(:user_name => user_name)
	ActiveRecord::Base.connection.close

	# If a user by this user_name was found and we can authenticate them
	if user && user.authenticate(password)
		# This is a valid user in our database
		# Keep track of the user by setting a session variable called 'user_id'
		session[:user_id] = user.id
		redirect('/')
	else 
		# Not a valid user
		redirect('/login2')
	end
end 


get '/login2' do 
	erb :login2
end
# Display registration form
get '/register' do
	erb :register
end

# Process registration data and add the new user
post '/register' do 
	# Create an instance of a user with the new data posted
	ActiveRecord::Base.establish_connection(
	:adapter => 'postgresql',
	:host => 'localhost',
	:database => 'photo'
)
	user = User.new(:user_name => params[:user_name], :email => params[:email], :password => params[:password])
	user.hash_password
	user.save
	ActiveRecord::Base.connection.close

	# We need to set a session variable or they will have to log in when going to the index page, which 
	# looks like a bug
	session[:user_id] = user.id

	# For our purposes, they are now authorized to see our protected content
	redirect('/')
end

# Display the current user 
get '/profile' do 
	erb :profile
end

# Log the user out
get '/logout' do
	# Clear out all the session variables. Now that the session value no longer exists, they will have to log in again
	session.clear
	redirect('/login')
end

get '/upload' do
	erb :upload
	end

post '/upload' do
	upload = Upload.new(:upload => params[:upload])
	upload.save

	session[:user_id] = user.id
	redirect('/')

end











