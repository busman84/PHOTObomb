require 'active_record'

# Establish a database connection 
ActiveRecord::Base.establish_connection(
	:adapter => 'postgresql',
	:host => 'localhost',
	:database => 'photo'
)



class Upload < ActiveRecord::Base


	end