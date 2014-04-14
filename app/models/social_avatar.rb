class SocialAvatar < ActiveRecord::Base
  attr_accessible :account, :avatar_url, :provider

  #checks if the avatar exists
  #
  def avatar_exists?
    SocialAvatar.where("social_avatars.provider = ? and social_avatars.account = ?", self.provider, self.account).present?
  end

end
