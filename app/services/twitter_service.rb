# This file is part of Social Micro Blog.
# 
# Social Micro Blog is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# Social Micro Blog is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see 
# <http://www.gnu.org/licenses/>.
#
# @author Johnathan Pulos <johnathan@missionaldigerati.org>
# @copyright Copyright 2012 Missional Digerati
require 'oauth'
require 'json'
require 'active_support/core_ext/hash/slice'

class TwitterService
	
	attr_accessor :credentials
	
	def latest(account, max)
		tweets = Array.new
		access_token = get_access_token
		puts access_token
		response = access_token.request(:get, "http://api.twitter.com/1.1/statuses/user_timeline.json?screen_name=#{account}&count=#{max}")
		results = JSON.parse(response.body)
		results.each do |tweet|
			# tweet['text'] = pp(tweet['text'])
			tweets << tweet.slice("id", "text")
		end
		tweets
	end
	
	private
		def get_access_token
			consumer = OAuth::Consumer.new(@credentials['consumer_key'], @credentials['consumer_secret'],
			    { :site => "http://api.twitter.com",
			      :scheme => :header
			    })
			  # now create the access token object from passed values
			  token_hash = { :oauth_token => @credentials['oauth_token'],
			                 :oauth_token_secret => @credentials['oauth_token_secret']
			               }
			  access_token = OAuth::AccessToken.from_hash(consumer, token_hash)
		end
	
	def pp(tweet)
		
	end

end