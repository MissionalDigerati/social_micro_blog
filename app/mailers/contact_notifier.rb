class ContactNotifier < ActionMailer::Base
  default from: "zombie.on.rails@gmail.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.contact_notifier.received.subject
  #
  def more_info_request(params)
		@params = params
		
		mail to: 'johnathan@missionaldigerati.org', subject: 'Requesting More Info About Ministry'
  end
end
