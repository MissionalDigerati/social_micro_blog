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
#
class SocialMediaController < ApplicationController
	before_filter :set_account_settings
  # List all social media
	#
	def index
		@social_media = SocialMedia.order("provider_created_datetime desc").page(params[:page]).per(20)
  end

	# List a specific social media item
	#
	def show
		@social_media = SocialMedia.where(["social_media.provider = ? and social_media.provider_id = ?", params[:provider], params[:provider_id]]).first
	end
	
	private
		# set the account settings
		#
		def set_account_settings
			settings = YAML::load(File.open(File.join(Rails.root,'config','services.yml')))
			@accounts = settings['accounts']
		end
end
