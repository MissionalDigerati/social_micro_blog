class SocialMedia < ActiveRecord::Base
  attr_accessible :content, :provider, :provider_created_datetime, :provider_id, :account

	#checks if the post exists
	#
	def post_exists?
		SocialMedia.where("social_media.provider = ? and social_media.provider_id = ?", self.provider, self.provider_id).present?
	end
	
	def creation_date
		self.provider_created_datetime.strftime("%l:%M %p - %e %B %Y")
	end

	def avatar
		social_avatar = SocialAvatar.where("social_avatars.provider = ? and social_avatars.account = ?", self.provider, self.account).first
		social_avatar.nil? ? nil : social_avatar.avatar_url
	end

end
