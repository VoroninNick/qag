class MessagesController < ApplicationController
	def new

	end

	def create
		params_message = params['message']
		@message = Message.new(params_message)

		respond_to do |format|
	      if @message.save
	        # Tell the UserMailer to send a welcome email after save
	        MessageMailer.new_message(@message).deliver
	 
	        #format.html { redirect_to(@message, notice: 'User was successfully created.') }
	        format.html { render inline: 'message successfully created.' }
	        format.json { render json: @message, status: :created, location: create_message_path(locale: I18n.locale) }
	      else
	        #format.html { render action: 'new' }
	        format.html { render inline: 'message creation failed.' }
	        format.json { render json: @message.errors, status: :unprocessable_entity }
	      end
    end

	end
end