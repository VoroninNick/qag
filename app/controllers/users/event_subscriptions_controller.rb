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

		if user_signed_in?
		render template: "devise/event_subscriptions/new"
		else
			render template: "devise/sessions/new"
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


end