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
#
require_relative "../../app/services/social_media_service.rb"
require_relative "../../app/services/twitter_service.rb"
require 'yaml'
require 'spec_helper'

describe SocialMedia do
	
	before(:each) do
		credentials = YAML::load(File.open(File.join(File.dirname(__FILE__), '..', 'config','services.yml')))['services']['twitter']
		@social_media = SocialMediaService.new(TwitterService.new, credentials)
	end

	it "should return the latest tweets", :vcr do
		@tweets = @social_media.latest('jpulos', 5)
		@tweets.empty?.should be_false
		@tweets.length.should eq(5)
	end
	
	it "should return valid attributes", :vcr do
		@tweets = @social_media.latest('jpulos', 5)
		@tweets.first['id'].to_s.empty?.should be_false
		@tweets.first['content'].to_s.empty?.should be_false
		@tweets.first['created'].to_s.empty?.should be_false
	end
	
end