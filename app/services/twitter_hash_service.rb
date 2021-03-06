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
require 'twitter-text'
require 'active_support/core_ext/hash/slice'

class TwitterhashService
  include Twitter::Autolink
	attr_reader :image_format, :video_service_format
	attr_accessor :credentials
	
	def setup(context)
		@credentials = context.credentials
		@image_format = context.image_format
		@video_service_format = context.video_service_format
	end
	
	def latest(account, max)
		tweets = Array.new
		access_token = get_access_token
		response = access_token.request(:get, "https://api.twitter.com/1.1/search/tweets.json?q=%23#{account}&count=#{max}")
		results = JSON.parse(response.body)
		results['statuses'].each do |tweet|
			new_tweet = {}
			new_tweet['id'] = tweet['id'].to_s
			new_tweet['content'] = pp(tweet)
			new_tweet['created'] = tweet['created_at']
			if tweet['user'].has_key?('profile_image_url')
				new_tweet['avatar'] = tweet['user']['profile_image_url']
			else
				new_tweet['avatar'] = ''
			end
			if tweet['user'].has_key?('screen_name')
				new_tweet['account'] = tweet['user']['screen_name']
			else
				new_tweet['account'] = account
				# Overwrite avatar so we do not get the wrong users avatar.  Hashtags do not have avatars
				#
				new_tweet['avatar'] = ''
			end
			tweets << new_tweet
		end
		tweets
	end
	
	private
		# Get an OAUTH access token
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
		
		# Create a pretty version of the tweet
		#
		def pp(tweet)
			content = tweet['text']
			images = find_images_in_entities(tweet)
			videos = find_video_services_in_entities(tweet)
			videos+images+"<p>"+auto_link(content)+"</p>"
		end
		
		# Find any images in the entities tag, and attach to content
		#
		def find_images_in_entities(tweet)
			images = ''
			if has_url_entities?(tweet)
				tweet['entities']['urls'].each do |url|
					if is_image?(url['expanded_url'])
						images += @image_format % [url['expanded_url']]
					end
				end
			end
			images
		end
		
		# looks for common video services, and embeds the video
		#
		def find_video_services_in_entities(tweet)
			videos = ''
			if has_url_entities?(tweet)
				tweet['entities']['urls'].each do |url|
					if has_video_sevice?(url['expanded_url'])
						videos += @video_service_format % [format_video_url(url['expanded_url'])]
					end
				end
			end
			videos
		end
		
		# does the tweet contain urls in its entities hash
		#
		def has_url_entities?(tweet)
			if tweet.has_key?('entities')
				if tweet['entities'].has_key?('urls') and !tweet['entities']['urls'].empty?
					return true
				end
			end
			return false
		end
		
		# is the url a popular video service
		#
		def has_video_sevice?(url)
			if url.include?('youtube.com')
				id = url.match(/v=([\w\-]*)&/i)
				return id.nil? ? false : true
			elsif url.include?('vimeo.com')
				true
			else
				false
			end
		end
		
		# is the url an image.  Uses extension to determine this
		#
		def is_image?(url)
			['.jpg', '.jpeg', '.png', '.gif', '.bmp', '.tif', '.tiff', '.xpng'].include?(File.extname(url))
		end
		
		# Format vimeos url correctly
		#
		def format_video_url(url)
			if url.include?('vimeo.com')
				player_url = url.gsub!(/\/w*\.*vimeo.com\//, "/player.vimeo.com/video/")
			elsif url.include?('youtube.com')
				id = url.match(/v=([\w\-]*)&/i)
				player_url = "http://www.youtube.com/embed/#{id[1]}?wmode=transparent"
			end
		end
end