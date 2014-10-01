class FormConfig < ActiveRecord::Base
  #acts_as_taggable_on :form_receivers
  attr_accessible :receiver_emails
  #attr_accessible :form_receiver_list
  attr_accessible :name

  rails_admin do
    navigation_label 'other'

    edit do
      field :name
      # field :form_receiver_list do
      #   help 'Use commas to separate e-mails'
      #   partial 'tag_list_with_suggestions'
      # end
      field :receiver_emails
    end
  end

end
