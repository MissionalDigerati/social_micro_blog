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
require 'rest_client'
require 'json'

class TwitterService
	
	attr_accessor :credentials
	
	def latest(account, max)
		tweets = Array.new
		url = "https://api.twitter.com/1/statuses/user_timeline.json?include_entities=true&include_rts=true&screen_name=#{account}&count=#{max}"
		request = RestClient.get(url)
		results = JSON.parse(request)
		results.each do |tweet|
			tweets << tweet.slice("id", "text")
		end
	end

end