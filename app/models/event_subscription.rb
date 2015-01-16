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

    configure :disabled do
      if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
        label asd
      end
    end
    configure :user do
      if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
        label asd
      end
    end
    configure :event do
      if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
        label asd
      end
    end
    configure :first_name do
      if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
        label asd
      end
    end
    configure :last_name do
      if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
        label asd
      end
    end
    configure :email do
      if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
        label asd
      end
    end
    configure :contact_phone do
      if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
        label asd
      end
    end

    list do
      field :disabled
      field :user do
        pretty_value do
          user_id = bindings[:object].user_id
          #full_name = bindings[:view].full_name(user_id)
          #user_email = bindings[:object].user_id.to_s
          user_email =  (u =  User.find(user_id)) ? u.email : u.id.to_s

          bindings[:view].link_to "#{user_email}", bindings[:view].rails_admin.show_path('user', user_email)
        end
      end
      field :event
      field :first_name
      field :last_name
      field :email
      field :contact_phone
    end

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