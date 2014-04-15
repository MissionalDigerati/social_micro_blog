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
require 'open-uri'
require 'json'
class JoshuaProjectService
	attr_reader :image_format, :video_service_format
	attr_accessor :credentials, :access, :api_feed_url
	
	# setup the class
	#
	def setup(context)
		@credentials = context.credentials
		@image_format = "<img src='%s' alt='Social Media Image' class='jp_api_profile'><br>"
		@api_feed_url = "http://jpapi.codingstudio.org/v1/people_groups/daily_unreached.json?api_key=#{@credentials['api_key']}&month=#{Date.today.strftime("%m")}&day=#{Date.today.strftime("%d")}"
	end
	
	# get the latest feed data
	#
	def latest(account, max)
		posts = Array.new
		items = JSON.parse(open(@api_feed_url).read)
		# Use todays date since it is new every day only
		#
		items.each do |item|
			post = {
				"id" => Date.today.strftime("%m%d%Y"),
				"created" => Time.now.to_s,
				"content" => pp_widget(item),
				"avatar"	=>	"http://joshuaproject.net/assets/img/jp_logo_color.png"
			}
			posts << post
		end
		posts
	end
	
	private
		def pp_widget(item)
			image_url = "http://www.joshuaproject.net/profiles/photos/#{item['PhotoAddress']}"
			image_html = @image_format % [image_url]
			title = "Please pray for the <a href='http://www.joshuaproject.net/peoples.php?peo3=#{item['PeopleID3']}'>#{item['PeopNameInCountry']}</a>"
			title += " of <a href='http://www.joshuaproject.net/countries.php?rog3=#{item['ROG3']}'>#{item['Ctry']}</a>"
			desc = ""
			desc += "<strong>Population</strong>: #{formatted(item['Population'])}<br>" unless item['Population'].nil?
			desc += "<strong>Language</strong>: #{item['PrimaryLanguageName']}<br>" unless item['PrimaryLanguageName'].nil?
			desc += "<strong>Religion</strong>: #{item['PrimaryReligionPC']}<br>" unless item['PrimaryReligionPC'].nil?
			desc += "<strong>Evangelical</strong>: #{formatted_percent(item['PercentEvangelical'])}<br>" unless item['PercentEvangelical'].nil?
			unless item['JPScale'].nil?
				scale_image_html = "<img src='http://www.joshuaproject.net/images/scale#{item['JPScale'].to_i.round}.jpg' alt='Social Media Image'>"
				desc += "<strong>Evangelical</strong>: <a href='http://www.joshuaproject.net/definitions.php'>#{get_scale_text(item['JPScale'])}</a> (<a href='http://www.joshuaproject.net/global-progress-scale.php'>#{item['JPScale']}</a> #{scale_image_html})<br>"
			end
			"#{image_html}<h3 class='post_title'>#{title}</h3><p class='post_desc'>#{desc}</p>"
		end
		
		def formatted(number)
			number.to_s.reverse.gsub(/...(?=.)/,'\&,').reverse
		end
		
		def formatted_percent(number)
			"#{'%.2f' % number}%"
		end
		
		def get_scale_text(scale)
			return "Status Unavailable" if ['1.0', '2.0'].include?(scale)
			return "Unreached" if ['1.1', '1.2'].include?(scale)
			return "Nominal Church" if ['2.1', '2.2'].include?(scale)
			"Established Church"
	  end

end