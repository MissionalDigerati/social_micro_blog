email_settings = YAML.load_file(File.join(Rails.root.to_s, "config", "config.yml"))[Rails.env]['gmail']
if Rails.env == 'production'
	ActionMailer::Base.smtp_settings = {
	  :address        => 'smtp.sendgrid.net',
	  :port           => '587',
	  :authentication => :plain,
	  :user_name      => ENV['SENDGRID_USERNAME'],
	  :password       => ENV['SENDGRID_PASSWORD'],
	  :domain         => 'heroku.com'
	}
	ActionMailer::Base.delivery_method = :smtp
end