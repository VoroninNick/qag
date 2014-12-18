class EventGalleryImage < ActiveRecord::Base
  has_and_belongs_to_many :event_gallery_albums, join_table: :event_gallery_albums_and_event_gallery_images
  has_and_belongs_to_many :events, join_table: :events_and_gallery_images
  attr_accessible :event_gallery_albums, :event_gallery_album_id, :event_gallery_album_ids
  attr_accessible :events, :event_id, :event_ids


  attr_accessible :published, :name, :short_description, :order_index

  has_attached_file :image, :styles => { :event_list_image => '180x120#'},
                    :url  => "/assets/#{self.name.underscore}/:id/avatar/:style/:basename.:extension",
                    :path => ":rails_root/public/assets/#{self.name.underscore}/:id/avatar/:style/:basename.:extension",
                    convert_options: {
                        event_list_image: "-quality 94 -interlace Plane",
                    }

  validates_attachment_file_name :image, :matches => [/png\Z/i, /jpe?g\Z/i, /gif\Z/i, /svg\Z/i]

  [:image].each do |paperclip_field_name|
    attr_accessible paperclip_field_name.to_sym, "delete_#{paperclip_field_name}".to_sym, "#{paperclip_field_name}_file_name".to_sym, "#{paperclip_field_name}_file_size".to_sym, "#{paperclip_field_name}_content_type".to_sym, "#{paperclip_field_name}_updated_at".to_sym, "#{paperclip_field_name}_file_name_fallback".to_sym, "#{paperclip_field_name}_alt".to_sym

    attr_accessor "delete_#{paperclip_field_name}".to_sym
  end

  translates :name, :short_description, :image_alt, :versioning => :paper_trail
  accepts_nested_attributes_for :translations
  attr_accessible :translations_attributes, :translations

  class Translation
    attr_accessible :locale, :published_translation, :name, :short_description, :image_alt

    # def published=(value)
    #   self[:published] = value
    # end

    rails_admin do
      visible false

      edit do
        field :locale, :hidden
        #field :published_translation
        field :name
        #field :short_description
        field :image_alt


      end
    end
  end

  rails_admin do
    navigation_label I18n.t('rails_admin.navigation_labels.events')
    label I18n.t("rails_admin.model_labels.#{self.abstract_model.model_name.underscore}")
    label_plural I18n.t("rails_admin.model_labels_plural.#{self.abstract_model.model_name.underscore}")

    edit do
      field :published
      field :translations, :globalize_tabs
      field :image

      #field :events
      #field :event_gallery_albums
    end
  end
end
