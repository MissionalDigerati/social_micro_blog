class SocialMedia < ActiveRecord::Base
  attr_accessible :content, :provider, :provider_created_datetime, :provider_id, :account

	 #checks if the post exists
	#
	def post_exists?
		SocialMedia.where("social_media.provider = '#{self.provider}' and social_media.provider_id = #{self.provider_id}").present?
	end
	
	def creation_date
		self.provider_created_datetime.strftime("%l:%M %p - %e %B %Y")
	end

end
