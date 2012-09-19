class SocialMedia < ActiveRecord::Base
  attr_accessible :content, :provider, :provider_created_datetime, :provider_id, :account
end
