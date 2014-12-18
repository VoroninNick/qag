class HomeContactInfo < ActiveRecord::Base
  self.table_name = :home_contact_infos

  attr_accessible :address,:address_at,:info_service_email, :info_service_phone, :support_email, :map_latitude, :map_longtitude

  translates :address,:address_at, :versioning => :paper_trail
  accepts_nested_attributes_for :translations
  attr_accessible :translations_attributes, :translations

  class Translation
    attr_accessible :locale, :published_translation, :address, :address_at

    # def published=(value)
    #   self[:published] = value
    # end

    rails_admin do
      visible false
      #parent HomePage

      edit do
        field :locale, :hidden
        field :published_translation

        field :address
        field :address_at


      end
    end
  end

  rails_admin do
    parent HomePage
    label I18n.t("rails_admin.model_labels.#{self.abstract_model.model_name.underscore}")
    label_plural I18n.t("rails_admin.model_labels_plural.#{self.abstract_model.model_name.underscore}")

    edit do
      field :translations, :globalize_tabs
      field :info_service_email
      field :info_service_phone
      field :support_email
      field :map_latitude
      field :map_longtitude
    end
  end
end
