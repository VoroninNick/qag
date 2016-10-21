class MessageMailer < ActionMailer::Base
	def new_message(message)
		@message = message

		default_to = 'p.korenev@voroninstudio.eu'
		to = FormConfig.first.receiver_emails.split(',').map{|s| s.gsub("\r\n", "") }.select(&:present?)
		if to.length == 0
			to = default_to
		end
		mail(template_path: 'mailers/message', template_name: 'new', from: 'support@voroninstudio.eu', to: to)
	end

	def new_call_back(call_back)
		@call_back = call_back

		default_to = 'p.korenev@voroninstudio.eu'
		to = FormConfig.second.receiver_emails.split(',').map{|s| s.gsub("\r\n", "") }.select(&:present?)
		if to.length == 0
			to = default_to
		end
		mail(template_path: 'mailers/call_back', template_name: 'new', from: 'support@voroninstudio.eu', to: to)
	end
end