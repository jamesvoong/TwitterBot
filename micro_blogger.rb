require 'jumpstart_auth'

class MicroBlogger
	attr_reader :client

	def initialize
		puts "Initializing MicroBlogger"
		@client = JumpstartAuth.twitter
	end

	def tweet(message)
		if message.size <= 140
			@client.update(message)
		else
			puts "Warning your tweet is greater than 140 characters."
		end
	end

	def run
		puts "Welcome to the JSL Twitter Client!"
		command = ""
		while command != "q"
			printf "enter command: "
	        input = gets.chomp
	        parts = input.split(" ")
	        command = parts[0]
	        case command
	           when 'q' then puts "Goodbye!"
	           when 't' then tweet(parts[1..-1].join(" "))
	           when 'dm' then dm(parts[1], parts[2..-1].join(" "))
	           when 'spam' then spam_my_followers(parts[1..-1].join(" "))
	           when 'elt' then everyones_last_tweet
	           when 'test' then do_test
	           else
	           puts "Sorry, I don't know how to #{command}"
	        end
		end
	end

	def dm(target, message)
	  puts "Trying to send #{target} this direct message:"
	  puts message
	  screen_names = @client.followers.collect { |follower| @client.user(follower).screen_name }
	  if screen_names.include? target
	  	modified_message = "d @#{target} #{message}"
	  	tweet(modified_message)
	  else
	  	puts "#{target} is not one of your followers."
	  end
	end

	def followers_list
		screen_names = []
		@client.followers.each do |follower|
			screen_names << @client.user(follower).screen_name
		end
		screen_names
	end

	def spam_my_followers (message)
		followers = self.followers_list
		followers.each do |follower|
			dm(follower,message)
		end
	end

	def everyones_last_tweet
		friends = @client.friends.to_a
		friends.each do |friend|
			puts "#{@client.user(friend).screen_name} posted:"
		end
	end

	def do_test
		friend = @client.friends.to_a
		puts @client.user(friend[1]).screen_name
		puts @client.user(friend[1]).tweet.text
	end
end

blogger = MicroBlogger.new
blogger.run