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
require_relative "../../app/services/photobucket_service.rb"
require 'yaml'
require 'spec_helper'

describe PhotobucketService do

	before(:each) do
		@credentials = YAML::load(File.open(File.join(File.dirname(__FILE__), '..', '..', 'config','services.yml')))['services']['photobucket']
		@photobucket = PhotobucketService.new
		@social_media = SocialMediaService.new(@twitter, @credentials)
		@photobucket.setup(@social_media)
	end
	
	context "setup" do
		
		it "should set the credentials attribute", :vcr do
			@photobucket.credentials.should eq(@credentials)
		end
		
		it "should set the image_format from SocialMedia Class", :vcr do
			@social_media.image_format = "<img src='test.html'/>"
			@photobucket.setup(@social_media)
			@photobucket.image_format.should eq("<img src='test.html'/>")
		end
		
	end
	
	context "latest" do
		
		it "should setup a RSS feed url with the username", :vcr do
			@photobucket.setup(@social_media)
			@photobucket.latest('OnSamePath', 1)
			@photobucket.rss_feed_url.should match("/OnSamePath/")
		end
		
		it "should get the latest image", :vcr do
			pb = @photobucket.latest('OnSamePath', 100)
			pb.length.should eq(2)
		end
		
		context "correct formatted post", :vcr do
			
			it "should have an id" do
				@pb_result = @photobucket.latest('OnSamePath', 1)
				@pb_result.first.has_key?("id").should be_true
				@pb_result.first["id"].empty?.should be_false
			end
			
			it "should have an content" do
				@pb_result = @photobucket.latest('OnSamePath', 1)
				@pb_result.first.has_key?("content").should be_true
				@pb_result.first["content"].empty?.should be_false
			end
			
			it "should have a created date" do
				@pb_result = @photobucket.latest('OnSamePath', 1)
				@pb_result.first.has_key?("created").should be_true
				@pb_result.first["created"].empty?.should be_false
			end
			
		end
		
	end
	
end