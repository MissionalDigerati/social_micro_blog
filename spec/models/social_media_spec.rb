require 'spec_helper'

describe SocialMedia do
	
	context "methods" do
		context "post_exists?" do
			
			it "should return true if the post exists" do
				social_media = FactoryGirl.create(:social_media)
				social_media.post_exists?.should be_true
			end
		
			it "should return false if the post does not exist" do
				social_media = FactoryGirl.build(:social_media, provider_id: 23398773)
				social_media.post_exists?.should be_false
			end
		
		end
		
	end
	
end
