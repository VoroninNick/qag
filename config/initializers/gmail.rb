# -*- encoding : utf-8 -*-
ActionMailer::Base.smtp_settings = {
    :address              => "smtp.gmail.com",
    :port                 => 587,
    :domain               => "voroninstudio.eu",
    :user_name            => "support@voroninstudio.eu",
    :password             => "Studiosupport123",
    :authentication       => "plain",
    :enable_starttls_auto => true
}#           