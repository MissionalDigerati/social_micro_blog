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
# http://infovore.org/archives/2006/08/02/getting-a-class-object-in-ruby-from-a-string-containing-that-classes-name/
# Initialize Class with String Kernel.const_get('Twitter')
require_relative "../../app/services/social_media_service.rb"
require_relative "../../app/services/twitter_service.rb"
require 'yaml'
require 'spec_helper'

describe TwitterService do
	
	before(:each) do
		@credentials = YAML::load(File.open(File.join(File.dirname(__FILE__), '..', 'config','services.yml')))['services']['twitter']
		@twitter = TwitterService.new
		@social_media = SocialMediaService.new(@twitter, @credentials)
		@twitter.setup(@social_media)
	end
	
	context "setup" do
		
		it "should set the credentials attribute", :vcr do
			tweets = @twitter.latest('jpulos', 1)
			@twitter.credentials.should eq(@credentials)
		end
		
		it "should set the image_format from SocialMedia Class", :vcr do
			@social_media.image_format = "<img src='test.html'/>"
			@twitter.setup(@social_media)
			tweets = @twitter.latest('jpulos', 1)
			@twitter.image_format.should eq("<img src='test.html'/>")
		end
		
		it "should set the video_service_format from SocialMedia Class", :vcr do
			@social_media.video_service_format = "<video url='test.html'/>"
			@twitter.setup(@social_media)
			tweets = @twitter.latest('jpulos', 1)
			@twitter.video_service_format.should eq("<video url='test.html'/>")
		end
		
	end
	
	it "should get the latest tweets", :vcr do
		tweets = @twitter.latest('jpulos', 10)
		tweets.length.should eq(10)
	end

	context "correct formatted post", :vcr do
		
		it "should have an id" do
			tweets = @twitter.latest('jpulos', 1)
			tweets.first.has_key?("id").should be_true
			tweets.first["id"].to_s.empty?.should be_false
		end
		
		it "should have an content" do
			tweets = @twitter.latest('jpulos', 1)
			tweets.first.has_key?("content").should be_true
			tweets.first["content"].empty?.should be_false
		end
		
		it "should have a created date" do
			tweets = @twitter.latest('jpulos', 1)
			tweets.first.has_key?("created").should be_true
			tweets.first["created"].empty?.should be_false
		end

		it "should have an avatar" do
			tweets = @twitter.latest('jpulos', 1)
			tweets.first.has_key?("avatar").should be_true
			tweets.first["avatar"].empty?.should be_false
		end
		
	end
	
	context "private methods" do
		
		context "#has_url_entities?" do
			
			it "should return true" do
				response = @twitter.send(:has_url_entities?, {'entities' => {'urls' => [{'expanded_url' => 'http://www.test.com'}]}})
				response.should be_true
			end
			
			it "should return false if urls empty" do
				response = @twitter.send(:has_url_entities?, {'entities' => {'urls' => []}})
				response.should be_false
			end
			
			it "should return false if entities missing" do
				response = @twitter.send(:has_url_entities?, {})
				response.should be_false
			end
			
		end
		
		context "has_video_sevice?" do
			
			it "returns true for youtube urls" do
				response = @twitter.send(:has_video_sevice?, 'http://www.youtube.com/watch?v=yv0zA9kN6L8&feature=g-logo-xit').should be_true
			end
			
			it "returns false for youtube urls without an id" do
				response = @twitter.send(:has_video_sevice?, 'http://www.youtube.com/watch?feature=g-logo-xit').should be_false
			end
			
			it "returns true for vimeo urls" do
				response = @twitter.send(:has_video_sevice?, 'http://www.vimeo.com/nggk112').should be_true
			end
			
			it "returns false for non video services" do
				response = @twitter.send(:has_video_sevice?, 'http://www.yahoo.com/nggk112').should be_false
			end
			
		end
		
		context "is_image?" do
			
			it "should return true on an image" do
				response = @twitter.send(:is_image?, 'http://www.vimeo.com/special.png').should be_true
			end
			
			it "should return false if not an image" do
				response = @twitter.send(:is_image?, 'http://www.vimeo.com/special.html').should be_false
			end
			
		end
		
		context "find_images_in_entities" do
			
			it "should return images in entities" do
				response = @twitter.send(:find_images_in_entities, {'entities' => {'urls' => [{'expanded_url' => 'http://www.test.com/image.jpg'}]}})
				response.should match("http://www.test.com/image.jpg")
			end
			
			it "should return nothing, if images do not exist in entities" do
				response = @twitter.send(:find_images_in_entities, {'entities' => {'urls' => [{'expanded_url' => 'http://www.test.com/image.html'}]}})
				response.empty?.should be_true
			end
			
		end
		
		context "find_video_services_in_entities" do
			
			it "should return video services in entities" do
				response = @twitter.send(:find_video_services_in_entities, {'entities' => {'urls' => [{'expanded_url' => 'http://www.youtube.com/watch?v=yv0zA9kN6L8&feature=g-logo-xit'}]}})
				response.should match("http://www.youtube.com/embed/yv0zA9kN6L8")
			end
			
			it "should return nothing, if a video service does not exist in entities" do
				response = @twitter.send(:find_video_services_in_entities, {'entities' => {'urls' => [{'expanded_url' => 'http://www.test.com/image.html'}]}})
				response.empty?.should be_true
			end
			
		end
		
		context "format_video_url" do
			
			it "should format the correct vimeo url" do
				response = @twitter.send(:format_video_url, 'http://vimeo.com/46294589')
				response.should match("http://player.vimeo.com/video/46294589")
				response = @twitter.send(:format_video_url, 'http://www.vimeo.com/46294589')
				response.should match("http://player.vimeo.com/video/46294589")
			end
			
			it "should return the correct youtube url" do
				response = @twitter.send(:format_video_url, 'http://www.youtube.com/watch?v=yv0zA9kN6L8&feature=g-logo-xit')
				response.should match("http://www.youtube.com/embed/yv0zA9kN6L8")
				response = @twitter.send(:format_video_url, 'http://www.youtube.com/watch?v=yv0zA9kN6L8&feature=g-logo-xit')
				response.should match("http://www.youtube.com/embed/yv0zA9kN6L8")
			end
			
		end
		
	end
	
end