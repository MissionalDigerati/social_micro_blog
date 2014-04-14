class SocialAvatar < ActiveRecord::Base
  attr_accessible :account, :avatar_url, :provider, :provider_id
end
