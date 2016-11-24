class Partner < ActiveRecord::Base
  attr_accessible *attribute_names
  attr_accessible :published, :name, :short_description, :link

  attr_accessible :social_twitter, :social_facebook, :social_odnoklassniki, :social_linked_in, :social_blogger, :social_vk, :social_google_plus

  image :avatar, :styles => { :about => '250x250#'},
                    :url  => "/uploads/#{self.name.underscore}/:id/avatar/:style/:basename.:extension",
                    :path => ":rails_root/public:url",
                    convert_options: {
                        about: "-quality 94 -interlace Plane",
                    }

  def get_social_links
    result = {}

    [:twitter, :facebook, :odnoklassniki, :linked_in, :blogger, :vk, :google_plus].each do |field_name|
      value = send("social_#{field_name}")
      if value && value.length > 0
        result[field_name] = value
      end
    end

    result
  end

  translates :name, :short_description, :avatar_alt, :link, :versioning => :paper_trail
  accepts_nested_attributes_for :translations
  attr_accessible :translations_attributes, :translations

  class Translation
    attr_accessible :locale, :published_translation, :name, :short_description, :avatar_alt, :link

    # def published=(value)
    #   self[:published] = value
    # end

    rails_admin do
      visible false

      edit do
        field :locale, :hidden
        field :published_translation do
          if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
            label asd
          end
        end
        field :name do
          if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
            label asd
          end
        end
        field :avatar_alt do
          if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
            label asd
          end
        end
        field :link do
          if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
            label asd
          end
        end
        field :short_description do
          if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
            label asd
          end
        end
      end
    end
  end

  rails_admin do
    navigation_label I18n.t('rails_admin.navigation_labels.footer')
    label I18n.t("rails_admin.model_labels.#{self.abstract_model.model_name.underscore}")
    label_plural I18n.t("rails_admin.model_labels_plural.#{self.abstract_model.model_name.underscore}")
    weight -1

    edit do
      field :published do
        if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
          label asd
        end
      end
      field :avatar do
        if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
          label asd
        end
      end
      field :translations, :globalize_tabs do
        if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
          label asd
        end
      end
    end
  end
end
