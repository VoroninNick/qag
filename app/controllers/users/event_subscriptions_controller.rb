class Users::EventSubscriptionsController < ApplicationController
	#before_filter do
	#	if !user_signed_in?
	#		#@user_form = User.new
	#		flash[:alert] = 'hello2'
	#	end
	#end

	#before_action :authenticate_user! do
	#	flash[:alert] = 'hello'
	#end

	# before_filter([
	#  :authenticate,
	#  :authorize,
	#  :warn_unless_confirmed
	# ])

	#render inline: "hello"

	def concatenate_flash(&block)
	  warning = flash[:warning].blank? ? [] : [ flash[:warning] ]
	  yield
	  warning << flash[:warning] unless warning.include? flash[:warning]
	  flash[:warning] = warning
	end

	def authenticate
	  concatenate_flash do
	    #authenticate_user!
			if !user_signed_in?
				flash[:logged_in] = false
			end
	  end
	end


	def warn_unless_confirmed!
	  concatenate_flash do
	    unless current_user.confirmed?
	      flash[:warning]=t(:remember_to_confirm )
	    end
	  end
	end

	def new
		flash[:title] = "Реєстрація на подію"
		flash[:unlogged_text] = {
			unlogged_header: "Ви не зареєтровані на сайті.",
			unlogged_text_1: "Для реєстрації на подію необхідно бути зареєстрованим на нашому сайті.",
			unlogged_text_2: "Якщо у Вас вже є аккаунт, тоді увійдіть використовуючи особисті дані."
		}
		


		authenticate
		#authorize
		if user_signed_in?
			@logged_in = false
			warn_unless_confirmed!
		end

		#render inline: 'new'

		@user = current_user

		@event = Event.where(id: params[:event_id])
		if @event.count >= 1
			@event = @event.first
		else
			@event = nil
		end

		required_template = ''

		if user_signed_in?
			required_template = "devise/event_subscriptions/new"
			#render template: "devise/event_subscriptions/new"
		else
			required_template = "devise/sessions/new"
			#render template: "devise/sessions/new"
		end

		if modal?
			html_source = render_to_string template: required_template
			data = { html: html_source }
			render inline: "#{data.to_json}"
		else
			#respond_to_on_destroy
			render template: required_template
		end
	end

	def create
		#render inline: request.method
		@event = Event.where(id: params[:event_id])
		if @event.count >= 1
			@event = @event.first
		else
			@event = nil
		end

		@user = current_user



		if @event
			@subscribed_event = @user.events.where(id: @event.id)
			if @subscribed_event.length > 0
				flash[:result] = "You already subscribed on this event"
			else
				flash[:result] = "You successfully subscribed on event"
				@event.users.push(@user)
			end
			
		end

		render template: "devise/event_subscriptions/create"
	end

	def unsubscribe_form
		params_event_id = params[:event_id]
		if user_signed_in? && params_event_id
			@event = Event.where(id: params_event_id)
			if @event.count > 0
				@event = @event.first

				if modal?
					html_source = render_to_string template: 'devise/event_subscriptions/unsubscribe_form.html'
					data = { html: html_source }
					render inline: "#{data.to_json}"
				else
					#respond_to_on_destroy
					render template: "devise/event_subscriptions/unsubscribe_form.html"
				end
			end
		else
			render inline: "error"
		end
	end

	def unsubscribe
		required_template = "devise/event_subscriptions/error"
			params_event_id = params[:event_id]
			if subscribed_on_event?(params_event_id)
				#render inline:"breakpoint"
				subscribed_events = current_user.events
				matched_events = subscribed_events.where(id: params_event_id)
				if matched_events.count > 0
					@event = matched_events.first
					subscribed_events.delete(@event)
					required_template = "devise/event_subscriptions/unsubscribed_successfully.html.slim"
				end
			end

			if modal?
				html_source = render_to_string template: required_template
				data = { html: html_source }
				render inline: "#{data.to_json}"
			else
				#respond_to_on_destroy
				render template: required_template
			end

	end


end