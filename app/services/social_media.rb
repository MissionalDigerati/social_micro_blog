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
class SocialMedia
	attr_reader :credentials, :max
	attr_accessor :provider
	
	def initialize(provider, credentials)
		@provider = provider
		@credentials = credentials
	end
	
	def latest(account, max = 20)
		provider.credentials = @credentials
		provider.latest(account, max)
	end
	
end