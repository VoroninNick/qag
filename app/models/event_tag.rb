class EventTag < ActiveRecord::Base

  has_and_belongs_to_many :events, join_table: :event_taggings
  attr_accessible :events, :event_id, :event_ids

  translates :name, :slug, :versioning => :paper_trail
  accepts_nested_attributes_for :translations
  attr_accessible :translations_attributes, :translations

  class Translation
    attr_accessible :locale, :published_translation, :name, :slug, :short_description, :full_description

    # def published=(value)
    #   self[:published] = value
    # end

    rails_admin do
      visible false

      edit do
        field :locale, :hidden
        field :name do
          if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
            label asd
          end
        end
        field :slug do
          if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
            label asd
          end
        end
      end
    end
  end

  rails_admin do
    navigation_label I18n.t('rails_admin.navigation_labels.events')
    label I18n.t("rails_admin.model_labels.#{self.abstract_model.model_name.underscore}")
    label_plural I18n.t("rails_admin.model_labels_plural.#{self.abstract_model.model_name.underscore}")

    edit do
      field :translations, :globalize_tabs do
        if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
          label asd
        end
      end
      field :events do
        if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
          label asd
        end
      end
    end
  end
end
