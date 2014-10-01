class HomeContactInfo < ActiveRecord::Base
  self.table_name = :home_contact_infos

  attr_accessible :address,:address_at,:info_service_email, :info_service_phone, :support_email, :map_latitude, :map_longtitude

  translates :address,:address_at, :versioning => :paper_trail
  accepts_nested_attributes_for :translations
  attr_accessible :translations_attributes, :translations

  class Translation
    attr_accessible :locale, :published_translation, :name, :short_description, :full_description, :avatar_alt

    # def published=(value)
    #   self[:published] = value
    # end

    rails_admin do
      edit do
        field :locale, :hidden
        field :published_translation
        field :name

        field :short_description
        field :full_description, :ck_editor
        field :background_alt


      end
    end
  end
end
