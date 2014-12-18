class EventSubscription < ActiveRecord::Base
  belongs_to :event
  belongs_to :user

  attr_accessible :event, :event_id
  attr_accessible :user, :user_id

  attr_accessible :first_name, :last_name, :email, :contact_phone

  accepts_nested_attributes_for :event, :allow_destroy => true
  attr_accessible :event_attributes

  accepts_nested_attributes_for :user, :allow_destroy => true
  attr_accessible :user_attributes

  rails_admin do
    navigation_label I18n.t('rails_admin.navigation_labels.events')
    label I18n.t("rails_admin.model_labels.#{self.abstract_model.model_name.underscore}")
    label_plural I18n.t("rails_admin.model_labels_plural.#{self.abstract_model.model_name.underscore}")
    weight 1

    edit do
      field :disabled
      field :user
      field :event
      field :first_name
      field :last_name
      field :email
      field :contact_phone

    end
  end
end