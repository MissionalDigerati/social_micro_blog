class SocialAvatar < ActiveRecord::Base
  attr_accessible :account, :avatar_url, :provider, :provider_id

  #checks if the avatar exists
  #
  def avatar_exists?
    SocialAvatar.where("social_avatars.provider = ? and social_avatars.provider_id = ?", self.provider, self.provider_id).present?
  end

end
