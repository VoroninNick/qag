class VoroninStudio::PageMetadata < ActiveRecord::Base
  self.table_name = "voronin_studio_page_metadata"
  attr_accessible :head_title, :meta_tags, :meta_description

  translates :head_title, :meta_tags, :meta_description, :versioning => :paper_trail
  attr_accessible :translations

  before_save :init_fields
  def init_fields
    page.translated_locales.each do |locale|
      page_translation = page.translations_by_locale[locale]
      if !translated_locales.include?(locale)
        t = Translation.new(locale: locale, voronin_studio_page_metadatum_id: self.id)
      else
        t = translations_by_locale[locale]
      end

      if !t.head_title || t.head_title == ''
        t.head_title = page_translation.name
      end
    end
  end

  # nested
  accepts_nested_attributes_for :translations, allow_destroy: true
  attr_accessible :translations_attributes

  belongs_to :page, polymorphic: true
  attr_accessible :page

  class Translation
    self.table_name = "voronin_studio_page_metadatum_translations"
    attr_accessible :locale, :head_title, :meta_tags, :meta_description

    rails_admin do
      field :locale, :hidden
      field :head_title do
        if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
          label asd
        end
      end
      field :meta_description do
        if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
          label asd
        end
      end
      field :meta_tags do
        if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
          label asd
        end
      end
    end
  end

  rails_admin do
    edit do
      field :translations, :globalize_tabs do
        if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
          label asd
        end
      end
    end
  end
end
