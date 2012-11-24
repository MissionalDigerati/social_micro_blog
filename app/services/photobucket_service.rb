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
# A class for pulling RSS feed for Photobucket
require 'nokogiri'
require 'open-uri'
class PhotobucketService
	attr_reader :image_format, :video_service_format
	attr_accessor :credentials, :access, :rss_feed_url
	
	# setup the class
	#
	def setup(context)
		@credentials = context.credentials
		@image_format = context.image_format
		@video_service_format = context.video_service_format
	end
	
	# get the latest feed data
	#
	def latest(account, max)
		posts = Array.new
		@rss_feed_url = "http://feed1340.photobucket.com/albums/f83/#{account}/account.rss"
		doc = Nokogiri::XML(open(@rss_feed_url))
		doc.xpath("//rss/channel/item").each do |item|
			post = Hash.new
			post['id']  = item.at_xpath("guid").text
			medium = item.at_xpath("media:content").attribute("medium").text
			post['content'] = (medium == "image") ? pp_image(item) : pp_video(item) 
			post['created'] = item.at_xpath("pubDate").text
			posts << post
		end
		posts
	end
	
	private	
		# is the url an image.  Uses extension to determine this
		#
		def is_image?(url)
			['.jpg', '.jpeg', '.png', '.gif', '.bmp', '.tif', '.tiff', '.xpng'].include?(File.extname(url))
		end
		
		# pretty print image content
		#
		def pp_image(item)
			"content"
		end
		
		# pretty print video content
		#
		def pp_video(item)
			"content"
		end
		
end