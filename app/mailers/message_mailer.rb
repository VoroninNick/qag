class MessageMailer < ActionMailer::Base
	def new_message(message)
		@message = message

		default_to = 'p.korenev@voroninstudio.eu'
		to = FormConfig.first.receiver_emails.split(',')
		if to.length == 0
			to = default_to
		end
		mail(template_path: 'mailers/message', template_name: 'new', from: 'support@voroninstudio.eu', to: to)
	end
end