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
class SubscribersController < ApplicationController
	before_filter :set_errors
		
	# A new subscriber
	#
	def new
		@subscriber = Subscriber.new
	end
	
	# Create a new subscriber
	#
	def create
		@subscriber = Subscriber.new(params[:subscriber])
		if @subscriber.valid? and params[:address].blank?
			gb = Gibbon.new("#{MC_API_KEY}")
			add_subscriber = gb.list_subscribe({:id => "#{MC_NEW_LIST_ID}", 		:email_address 		=> params[:subscriber][:email], 
																																					:send_welcome 		=> false, 
																																					:merge_vars 			=> {	'FNAME' 		=> 	"#{params[:subscriber][:fname]}", 
																																																	'LNAME' 		=> 	"#{params[:subscriber][:lname]}"
																																																}
												})
			if add_subscriber
				flash[:notice] = "Thank you for subscribing to our newsletter.  You will receive an email to confirm your subscription."
				redirect_to root_url
			else
				flash[:error] = "We had a problem adding you to the email list.  Pleas try again later."
				redirect_to '/subscribe'
			end
     else
			[:email, :fname, :lname].each do |s|
				@errors[s] = @subscriber.errors.messages[s].join('. ') unless @subscriber.errors.messages[s].blank?
			end
      render :action => 'new'
     end
	end
	
	private
		# set the errors var
		#
		def set_errors
			@errors = {:fname => '', :lname => '', :email => ''}
		end
end
