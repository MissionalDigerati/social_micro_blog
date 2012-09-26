module ContactHelper
	
	# sends a string error if the error exists
	#
	def has_error?(field)
		return ' error' unless @errors[field].blank?
	end
	
	# display Twitter Bootstrap error if the error exists
	#
	def display_if_has_error(field)
		return "<span class='help-inline'>#{@errors[field]}</span>".html_safe unless @errors[field].blank?
	end
end
