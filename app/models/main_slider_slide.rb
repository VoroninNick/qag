class MainSliderSlide < ActiveRecord::Base
  attr_accessible :name, :short_description, :full_description, :published, :order_index

  has_attached_file :background, :styles => { banner: '2100x1200#' },
                    :url  => '/assets/articles/:id/:style/:basename.:extension',
                    :path => ':rails_root/public/assets/articles/:id/:style/:basename.:extension',
                    convert_options: {
                        background: "-quality 94 -interlace Plane",
                    }

  [:background].each do |paperclip_field_name|
    attr_accessible paperclip_field_name.to_sym, "delete_#{paperclip_field_name}".to_sym, "#{paperclip_field_name}_file_name".to_sym, "#{paperclip_field_name}_file_size".to_sym, "#{paperclip_field_name}_content_type".to_sym, "#{paperclip_field_name}_updated_at".to_sym, "#{paperclip_field_name}_file_name_fallback".to_sym, "#{paperclip_field_name}_alt".to_sym

    attr_accessor "delete_#{paperclip_field_name}".to_sym
  end

  translates :name, :short_description, :full_description, :background_alt, :versioning => :paper_trail
  accepts_nested_attributes_for :translations
  attr_accessible :translations_attributes, :translations

  class Translation
    attr_accessible :locale, :published_translation, :name, :short_description, :full_description, :background_alt

    # def published=(value)
    #   self[:published] = value
    # end

    rails_admin do
      visible false

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

  rails_admin do
    parent HomePage

    edit do
      field :published
      field :order_index
      field :translations, :globalize_tabs
      group :image_data do
        field :background, :paperclip
        field :background_file_name_fallback
      end
    end
  end
end
