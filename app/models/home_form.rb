class HomeForm < ActiveRecord::Base
  attr_accessible :name, :phone, :email, :message, :locale

  rails_admin do
    visible false
    navigation_label I18n.t('rails_admin.navigation_labels.other')
    label I18n.t("rails_admin.model_labels.#{self.abstract_model.model_name.underscore}")
    label_plural I18n.t("rails_admin.model_labels_plural.#{self.abstract_model.model_name.underscore}")
  end
end
