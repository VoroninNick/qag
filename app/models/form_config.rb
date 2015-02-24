class FormConfig < ActiveRecord::Base
  #acts_as_taggable_on :form_receivers
  attr_accessible :receiver_emails
  #attr_accessible :form_receiver_list
  attr_accessible :name

  rails_admin do
    navigation_label I18n.t('rails_admin.navigation_labels.other')
    label I18n.t("rails_admin.model_labels.#{self.abstract_model.model_name.underscore}")
    label_plural I18n.t("rails_admin.model_labels_plural.#{self.abstract_model.model_name.underscore}")

    edit do
      field :name
      # field :form_receiver_list do
      #   help 'Use commas to separate e-mails'
      #   partial 'tag_list_with_suggestions'
      # end
      field :receiver_emails do
        if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
          label asd
        end
      end
    end
  end

end
