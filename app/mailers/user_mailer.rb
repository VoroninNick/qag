class UserMailer < Devise::Mailer
  helper :application # gives access to all helpers defined within `application_helper`.
  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`

  #default reply_to: "no-reply@qagroup.com.ua", from: "QA Group <support@qagroup.com.ua>"

  def confirmation_instructions(record, token, opts={})


    #@token_return_to = opts[:token_return_to]
    @token_registration_location = opts[:token_registration_location]
    @token_registration_event_id = opts[:token_registration_event_id]
    #@token_return_to = 'hello'
    super
    #@token = token
    #devise_mail(record, :confirmation_instructions, opts)
  end

  def test_mail
    mail(subject: "test",
         #to: resource.email,
         #from: mailer_sender(devise_mapping),
         #reply_to: mailer_reply_to(devise_mapping),
         template_path: "mailers/message/",
         template_name: "test")
  end
end