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
class ContactController < ApplicationController
	before_filter :set_errors
	
	# request more info
	#
  def learn_more
  end

	# post the learn more form
	#
	def submit_learn_more_form
		@errors[:name] = 'Please provide your name.' if params[:name].blank?
		@errors[:email] = 'Please provide your email address.' if params[:email].blank?
		@errors[:email] = 'Please provide a valid email address.' unless valid_email
		
		if @errors[:name].blank? and @errors[:email].blank? and params[:address].blank?
			flash[:error] = nil
			flash[:notice] = 'Thank you for your request.  We will contact you shortly.'
			render :action => :learn_more
		else
			flash[:notice] = nil
			flash[:error] = 'Unable to submit your request.'
			render :action => :learn_more
		end
	end
	
	private
		# set the errors var
		#
		def set_errors
			@errors = {:name => '', :email => ''}
		end
		
	protected
		# validate the email
		#
		def valid_email

		  email_regex = %r{
		    ^ # Start of string
		    [0-9a-z] # First character
		    [0-9a-z.+]+ # Middle characters
		    [0-9a-z] # Last character
		    @ # Separating @ character
		    [0-9a-z] # Domain name begin
		    [0-9a-z.-]+ # Domain name middle
		    [0-9a-z] # Domain name end
		    $ # End of string
		  }xi # Case insensitive

		  params[:email] =~ email_regex ? true : false
		end

end
