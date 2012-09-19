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
require_relative "../../app/services/social_media.rb"
require_relative "../../app/services/twitter_service.rb"
require 'yaml'

require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = File.join(File.dirname(__FILE__), 'vcr', 'rake_task')
  c.hook_into :webmock # or :fakeweb
end

settings = YAML::load(File.open(File.join(File.dirname(__FILE__), '..', '..','config','services.yml')))
accounts = settings['accounts']
twitter_credentials = settings['services']['twitter']
namespace :social_media do

	desc "Update all existing social media in the database"
	task :update do
		VCR.use_cassette('update') do
			twitter = SocialMedia.new(TwitterService.new, twitter_credentials)
			puts twitter.latest('jpulos', 10)
		end
	end
	
end