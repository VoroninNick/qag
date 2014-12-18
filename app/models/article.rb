class Article < ActiveRecord::Base
  attr_accessible :published, :slug, :name, :short_description, :full_description, :release_date

  has_attached_file :avatar, :styles => { :article_list_small_thumb => '360x300#', related_irticle_thumb: '600x500#'},
                    :url  => "/assets/#{self.name.underscore}/:id/avatar/:style/:basename.:extension",
                    :path => ":rails_root/public/assets/#{self.name.underscore}/:id/avatar/:style/:basename.:extension",
                    convert_options: {
                      article_list_small_thumb: "-quality 94 -interlace Plane",
                      related_irticle_thumb: "-quality 94 -interlace Plane"
                    }

  has_attached_file :banner, :styles => { :banner => '2100x500#'},
                    :url  => "/assets/#{self.name.underscore}/:id/banner/:style/:basename.:extension",
                    :path => ":rails_root/public/assets/#{self.name.underscore}/:id/banner/:style/:basename.:extension",
                    convert_options: {
                        banner: "-quality 94 -interlace Plane",
                    }

  validates_attachment_file_name :avatar, :matches => [/png\Z/i, /jpe?g\Z/i, /gif\Z/i, /svg\Z/i]
  validates_attachment_file_name :banner, :matches => [/png\Z/i, /jpe?g\Z/i, /gif\Z/i, /svg\Z/i]


  [:avatar, :banner].each do |paperclip_field_name|
    attr_accessible paperclip_field_name.to_sym, "delete_#{paperclip_field_name}".to_sym, "#{paperclip_field_name}_file_name".to_sym, "#{paperclip_field_name}_file_size".to_sym, "#{paperclip_field_name}_content_type".to_sym, "#{paperclip_field_name}_updated_at".to_sym, "#{paperclip_field_name}_file_name_fallback".to_sym, "#{paperclip_field_name}_alt".to_sym

    attr_accessor "delete_#{paperclip_field_name}".to_sym
  end

  translates :name, :slug, :short_description, :full_description, :avatar_alt, :banner_alt, :versioning => :paper_trail
  accepts_nested_attributes_for :translations, allow_destroy: true
  attr_accessible :translations_attributes, :translations

  class Translation
    attr_accessible :locale, :slug, :published_translation, :name, :short_description, :full_description

    # def published=(value)
    #   self[:published] = value
    # end

    before_save do
      self.slug = self.name.parameterize if !self.slug || self.slug == ''
      self.slug = self.slug.parameterize.underscore

      self.avatar_alt = self.name if !self.avatar_alt || self.avatar_alt == ''
      self.banner_alt = self.name if !self.banner_alt || self.banner_alt == ''
    end

    rails_admin do
      visible false
      edit do
        field :locale, :hidden
        #field :published_translation
        field :name
        field :slug do
          label "url"
        end
        field :short_description
        field :full_description, :ck_editor
        field :avatar_alt
        field :banner_alt

      end
    end
  end

  validates_with UniqueSlugValidator


  rails_admin do
    navigation_label I18n.t('rails_admin.navigation_labels.articles')
    label I18n.t("rails_admin.model_labels.#{self.abstract_model.model_name.underscore}")
    label_plural I18n.t("rails_admin.model_labels_plural.#{self.abstract_model.model_name.underscore}")

    edit do
      field :published do
        #label get_field_label(self)
        #label get_field_label
      end
      field :translations, :globalize_tabs
      field :avatar
      #field :avatar_file_name_fallback

      field :banner
      #field :banner_file_name_fallback

    end
  end
end
