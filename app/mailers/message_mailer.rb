class MessageMailer < ActionMailer::Base
	def new_message(message)
		@message = message
		mail(template_path: 'mailers/message', template_name: 'new', from: 'support@voroninstudio.eu', to: 'p.korenev@voroninstudio.eu')
	end
end