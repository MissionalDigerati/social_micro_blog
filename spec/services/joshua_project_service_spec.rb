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
require_relative "../../app/services/social_media_service.rb"
require_relative "../../app/services/joshua_project_service.rb"
require 'spec_helper'
describe JoshuaProjectService do

	before(:each) do
		@credentials = YAML::load(File.open(File.join(File.dirname(__FILE__), '..', 'config','services.yml')))['services']['joshua_project']
		@jp = JoshuaProjectService.new
		@social_media = SocialMediaService.new(@jp, @credentials)
		@jp.setup(@social_media)
	end
	
	context "setup" do
		
		it "should set the credentials attribute", :vcr do
			@jp.credentials.should eq(@credentials)
		end
		
		it "should set the image_format from SocialMedia Class", :vcr do
			@social_media.image_format = "<img src='test.html'/>"
			@jp.setup(@social_media)
			@jp.image_format.should eq("<img src='test.html'/>")
		end
		
		it "should set the api_feed_url" do
			@jp.api_feed_url.empty?.should be_false
		end
		
	end
	
	context "latest" do
		
		it "should get the latest people group", :vcr do
			jp_latest = @jp.latest('', 1)
			jp_latest.empty?.should be_false
		end
		
	end
	
	context "correct formatted post", :vcr do
		
		it "should have an id" do
			jp_result = @jp.latest('', 1)
			jp_result.first.has_key?("id").should be_true
			jp_result.first["id"].empty?.should be_false
		end
		
		it "should have an content" do
			jp_result = @jp.latest('', 1)
			jp_result.first.has_key?("content").should be_true
			jp_result.first["content"].empty?.should be_false
		end
		
		it "should have a created date" do
			jp_result = @jp.latest('', 1)
			jp_result.first.has_key?("created").should be_true
			jp_result.first["created"].empty?.should be_false
		end
		
	end
	
	context "private methods" do
		
		it "should return a correctly formatted number method: formatted()" do
			response = @jp.send(:formatted, '2000000')
			response.should eq('2,000,000')
		end
		
		it "should return a proper percentage method: formatted_percent()" do
			response = @jp.send(:formatted_percent, '2.0')
			response.should eq('2.00%')
		end
		
		it "should return the correct scale text method: get_scale_text()" do
			@jp.send(:get_scale_text, '2.0').should eq('Status Unavailable')
			@jp.send(:get_scale_text, '1.2').should eq('Unreached')
			@jp.send(:get_scale_text, '2.1').should eq('Nominal Church')
			@jp.send(:get_scale_text, '3.0').should eq('Established Church')
		end
		
	end
	
end