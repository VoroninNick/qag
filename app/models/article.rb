class Article < ActiveRecord::Base
  attr_accessible :published, :slug, :name, :short_description, :full_description, :release_date

  has_one :page_metadata, :class_name => 'VoroninStudio::PageMetadata', as: :page
  attr_accessible :page_metadata

  accepts_nested_attributes_for :page_metadata
  attr_accessible :page_metadata_attributes

  has_attached_file :avatar, :styles => { :article_list_small_thumb => '360x300#', related_irticle_thumb: '600x500#', :article_list_large_thumb => "690x575#"},
                    :url  => "/assets/#{self.name.underscore}/:id/avatar/:style/:basename.:extension",
                    :path => ":rails_root/public/assets/#{self.name.underscore}/:id/avatar/:style/:basename.:extension",
                    convert_options: {
                      article_list_small_thumb: "-quality 94 -interlace Plane",
                      related_irticle_thumb: "-quality 94 -interlace Plane",
                      article_list_large_thumb: "-quality 94 -interlace Plane"
                    }

  has_attached_file :banner, :styles => { :banner => '2100x500#'},
                    :url  => "/assets/#{self.name.underscore}/:id/banner/:style/:basename.:extension",
                    :path => ":rails_root/public/assets/#{self.name.underscore}/:id/banner/:style/:basename.:extension",
                    convert_options: {
                        banner: "-quality 94 -interlace Plane",
                    }

  validates_attachment_file_name :avatar, :matches => [/png\Z/i, /jpe?g\Z/i, /gif\Z/i, /svg\Z/i]
  validates_attachment_file_name :banner, :matches => [/png\Z/i, /jpe?g\Z/i, /gif\Z/i, /svg\Z/i]

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true

  [:avatar, :banner].each do |paperclip_field_name|
    attr_accessible paperclip_field_name.to_sym, "delete_#{paperclip_field_name}".to_sym, "#{paperclip_field_name}_file_name".to_sym, "#{paperclip_field_name}_file_size".to_sym, "#{paperclip_field_name}_content_type".to_sym, "#{paperclip_field_name}_updated_at".to_sym, "#{paperclip_field_name}_file_name_fallback".to_sym, "#{paperclip_field_name}_alt".to_sym

    attr_accessor "delete_#{paperclip_field_name}".to_sym
  end

  attr_accessible :show_toned_avatar, :show_toned_banner

  scope :published, -> { where(published: true) }

  translates :name, :slug, :short_description, :full_description, :avatar_alt, :banner_alt, :versioning => :paper_trail
  accepts_nested_attributes_for :translations, allow_destroy: true
  attr_accessible :translations_attributes, :translations

  class Translation
    attr_accessible :locale, :slug, :published_translation, :name, :short_description, :full_description



    # def published=(value)
    #   self[:published] = value
    # end

    # before_save do
    #   self.slug = self.name.parameterize if !self.slug || self.slug == ''
    #   self.slug = self.slug.parameterize.underscore
    #
    #   self.avatar_alt = self.name if !self.avatar_alt || self.avatar_alt == ''
    #   self.banner_alt = self.name if !self.banner_alt || self.banner_alt == ''
    # end

    before_validation :fix_slug

    def fix_slug
      locale_was = I18n.locale
      temp_locale = locale_was
      temp_locale = :ru if I18n.locale == :uk

      self.slug = self.name if !self.slug || self.slug == ''

      I18n.with_locale(temp_locale) do |locale|
        self.slug = self.slug.parameterize
      end
    end

    rails_admin do

      # [:name, :slug, :short_description, :full_description, :avatar_alt, :banner_alt].each do |field_name|
      #   configure field_name do
      #     label I18n.t("rails_admin.field_labels.#{field_name}")
      #     type :ck_editor  if [:full_description].include?(field_name)
      #   end
      # end

      visible false
      edit do
        field :locale, :hidden
        #field :published_translation
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
        field :short_description do
          if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
            label asd
          end
        end
        field :full_description, :ck_editor do
          if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
            label asd
          end
        end
        field :avatar_alt do
          if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
            label asd
          end
        end
        field :banner_alt do
          if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
            label asd
          end
        end

      end
    end
  end

  def fix_slug
    self.translations.each do |t|
      t.fix_slug
      #t.save
    end
  end

  def self.fix_slug_for_all
    EventTag.all.each do |t|
      t.fix_slug
    end
  end

  before_validation :fix_slug

  validates_with UniqueSlugValidator


  rails_admin do
    navigation_label I18n.t('rails_admin.navigation_labels.articles')
    label I18n.t("rails_admin.model_labels.#{self.abstract_model.model_name.underscore}")
    label_plural I18n.t("rails_admin.model_labels_plural.#{self.abstract_model.model_name.underscore}")
    # [:published, :translations, :avatar, :banner, :page_metadata].each do |field_name|
    #   configure field_name do
    #     label I18n.t("rails_admin.field_labels.#{field_name}")
    #   end
    # end
    weight -10

    edit do
      field :published do
        #label get_field_label(self)
        #label get_field_label
        if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
          label asd
        end

      end
      field :translations, :globalize_tabs do
        if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
          label asd
        end
      end
      field :avatar do
        if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
          label asd
        end
      end

      field :show_toned_avatar
      #field :avatar_file_name_fallback

      field :banner do
        if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
          label asd
        end
      end

      field :show_toned_banner

      #field :banner_file_name_fallback
      field :page_metadata do
        if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
          label asd
        end
      end
    end
  end
end
