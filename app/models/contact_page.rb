class ContactPage < ActiveRecord::Base
  has_seo_tags
  has_sitemap_record

  attr_accessible *attribute_names

  translates :address, :versioning => :paper_trail
  accepts_nested_attributes_for :translations, allow_destroy: true
  attr_accessible :translations_attributes, :translations

  class Translation
    attr_accessible :locale
    attr_accessible :address

    rails_admin do
      field :locale, :hidden
      field :address
    end
  end

  rails_admin do
    navigation_label I18n.t("rails_admin.navigation_labels.pages")
    label I18n.t("rails_admin.model_labels.#{self.abstract_model.model_name.underscore}")
    label_plural I18n.t("rails_admin.model_labels_plural.#{self.abstract_model.model_name.underscore}")
    weight 3

    edit do
      #field :content, :ck_editor
      field :translations, :globalize_tabs
      field :seo_tags
      field :sitemap_record
    end
  end
end
