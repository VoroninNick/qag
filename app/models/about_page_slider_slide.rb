class AboutPageSliderSlide < ActiveRecord::Base
  attr_accessible :name, :short_description, :full_description, :published, :order_index

  has_attached_file :background, :styles => { banner: {geometry: '2100x650#'}, bw_banner: {geometry: '2100x650#'}, sepia_banner: '2100x1200#' },
                    :url  => "/assets/#{self.name.underscore}/:id/background/:style/:basename.:extension",
                    :path => ":rails_root/public/assets/#{self.name.underscore}/:id/background/:style/:basename.:extension",
                    convert_options: {
                        banner: "-quality 94 -interlace Plane",
                        sepia_banner: "-quality 94 -interlace Plane -fill beige",
                        :bw_banner => '-quality 94 -interlace Plane -colorspace Gray'
                    }

  validates_attachment_file_name :background, :matches => [/png\Z/i, /jpe?g\Z/i, /gif\Z/i, /svg\Z/i]

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
    #parent HomePage
    navigation_label "About page"
    weight -10
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
