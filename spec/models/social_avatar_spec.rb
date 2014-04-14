require 'spec_helper'

describe SocialAvatar do
    
    context "methods" do
        context "avatar_exists?" do
            
            it "should return true if the post exists" do
                social_avatar = FactoryGirl.create(:social_avatar)
                social_avatar.avatar_exists?.should be_true
            end
        
            it "should return false if the post does not exist" do
                social_avatar = FactoryGirl.build(:social_avatar, provider_id: 23398773)
                social_avatar.avatar_exists?.should be_false
                social_avatar.avatar_exists?.should_not be_nil
            end
        
        end
        
    end
    
end
