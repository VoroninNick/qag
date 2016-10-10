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
			unlogged_header: "Ви не зареєcтровані на сайті.",
			unlogged_text_1: "Для реєстрації на подію необхідно бути зареєстрованим на нашому сайті.",
			unlogged_text_2: "Якщо у Вас вже є аккаунт, тоді увійдіть використовуючи особисті дані."
		}



		authenticate
		#authorize
		if user_signed_in?
			@logged_in = false
			#@logged_in = true
			warn_unless_confirmed!
		#else

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

		required_sign_in = false

		if !required_sign_in || user_signed_in?
			required_template = "devise/event_subscriptions/new"
			#render template: "devise/event_subscriptions/new"

		else
			required_template = "devise/sessions/new"
			#render template: "devise/sessions/new"
	 	end

		if modal?
			 html_source = render_to_string template: required_template
			 data = {controller: "users/event_subscriptions", action: "new", html: html_source }
			 render inline: "#{data.to_json}"
		else
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

		event_subscription_data = params[:user]

		if @event
			condition_str = ""
			user_id_condition_str = current_user ? "user_id = #{current_user.id}" : nil

			condition_str = "#{user_id_condition_str.try{|s| s + " or " }} email = '#{event_subscription_data["email"]}'"
			@event_subscription = EventSubscription.where(event_id: @event.id).where(condition_str)
			#@subscribed_event = @user.events.where(id: @event.id)
			if @event_subscription.count > 0
				flash[:result] = "You already subscribed on this event"
				@already_registered = true
			else
				@event_subscription = EventSubscription.new
				@event_subscription.user_id = current_user.try(:id)
				@event_subscription.event_id = @event.id

				event_subscription_data.each_pair do |key, value|
					@event_subscription.send("#{key}=", value)
				end

				if @event_subscription.save
					flash[:result] = "You successfully subscribed on event"
					#@event.users.push(@user)
				end
			end
			
		end





		required_template = "devise/event_subscriptions/create"

		if modal?
			html_source = render_to_string template: required_template
			data = {controller: "users/event_subscriptions", action: "new", html: html_source, decline_button_text: t("layout.buttons.unregister")  }

			if @event
				data[:decline_button_link] = event_unsubscription_form_path(event_id: @event.id)
			end

			render inline: "#{data.to_json}"
		else
			#respond_to_on_destroy
			render template: required_template
		end
	end

	def unsubscribe_form
		params_event_id = params[:event_id]

		#required_template = "devise/event_subscriptions/error"

		if !user_signed_in?
			redirect_to controller: "users/sessions", action: "new"
		else
			if params_event_id
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
				required_template = 'devise/event_subscriptions/error'
				if modal?
					html_source = render_to_string template: required_template
					data = {}
					data = { html: html_source }

					@errors = { form: :already_unsubscribed }

					data[:errors] = { :form => 'invalid event' }

					render inline: "#{data.to_json}"
				else
					render template: required_template
				end
			end
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
				data = { html: html_source, subscribe_button_text: t("layout.buttons.register") }

				if @event
					data[:subscribe_button_link] = new_event_subscription_path(event_id: @event.id)
				end

				render inline: "#{data.to_json}"
			else
				#respond_to_on_destroy
				render template: required_template
			end

	end


end