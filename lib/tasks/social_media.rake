# This file is part of Social Micro Blog.
# 
# Social Micro Blog is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
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
require_relative "../../app/services/social_media_service.rb"
require_relative "../../app/services/twitter_service.rb"
require_relative "../../app/services/twitter_hash_service.rb"
require_relative "../../app/services/joshua_project_service.rb"
require 'yaml'

settings = YAML::load(File.open(File.join(File.dirname(__FILE__), '..', '..','config','services.yml')))
accounts = settings['accounts']
namespace :social_media do

	desc "Update all existing social media in the database"
	task :update => [:environment] do
		accounts.each do |key, val|
			# http://infovore.org/archives/2006/08/02/getting-a-class-object-in-ruby-from-a-string-containing-that-classes-name/
			# Initialize Class with String Kernel.const_get('Twitter')
			social_media = SocialMediaService.new(Kernel.const_get("#{val['provider'].titlecase.delete('^a-zA-Z')}Service").new, settings['services'][val['provider']])
			posts = social_media.latest(val['username'], val['pull_total'])
			posts.each do |post|
				provider = val['provider'].downcase
				new_social_media = SocialMedia.new(
				{
					provider: provider,
					account: val['username'],
					provider_id: post['id'], 
					content: post['content'], 
					provider_created_datetime: post['created']
				})
				new_social_media.save unless new_social_media.post_exists?
				# Update or create the avatar
				#
				if val['avatar_url']
					post['avatar'] = val['avatar_url']
				end
				unless post['avatar'].nil?
					social_avatar = SocialAvatar.find_or_initialize_by_account_and_provider(val['username'], provider)
					social_avatar.update_attributes(avatar_url: post['avatar'])
				end
			end
		end
	end
	
end