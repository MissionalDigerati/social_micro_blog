require 'spec_helper'

describe SocialMedia do
	
	context "methods" do
		context "post_exists?" do
			
			it "should return true if the post exists" do
				social_media = FactoryGirl.create(:social_media)
				social_media.post_exists?.should be_true
			end
		
			it "should return false if the post does not exist" do
				social_media = FactoryGirl.create(:social_media, provider_id: 23398773)
				social_media.post_exists?.should be_false
			end
		
		end

		context "avatar" do

			it "should return the appropriate avatar" do
				social_media = FactoryGirl.create(:social_media)
				social_avatar = FactoryGirl.create(:social_avatar, account: social_media.account, provider: social_media.provider, avatar_url: 'http://www.thecorrect.com')
				social_media.avatar.should eq('http://www.thecorrect.com')
			end

			it "should return nil if no avatar" do
				social_media = FactoryGirl.create(:social_media)
				social_media.avatar.should be_nil
			end

		end
		
	end
	
end
