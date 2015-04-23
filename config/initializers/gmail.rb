# -*- encoding : utf-8 -*-
ActionMailer::Base.smtp_settings = {
    :address              => "smtp.gmail.com",
    :port                 => 587,
    :domain               => "voroninstudio.eu",
    :user_name            => "support@voroninstudio.eu",
    :password             => "Studiosupport123",
    :authentication       => "plain",
    :enable_starttls_auto => true,
    :from                 => "QA group"
}#

# ActionMailer::Base.smtp_settings = {
#     :address              => "smtp-2.1gb.ua",
#     :port                 => 25,
#     :domain               => "qagroup.com.ua",
#     :user_name            => "info@qagroup.com.ua",
#     :password             => "bec4858d",
#     :authentication       => "plain",
#     :enable_starttls_auto => true,
#     :from                 => "info@qagroup.com.ua"
# }