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

  belongs_to :about_page
  attr_accessible :about_page

  before_create do
    self.about_page = AboutPage.first
  end

  class Translation
    attr_accessible :locale, :published_translation, :name, :short_description, :full_description, :background_alt

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
          #label I18n.t("rails_admin.field_labels.#{method_name}")
        end
        field :name do
          #label I18n.t("rails_admin.field_labels.#{method_name}")
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
        field :background_alt do
          if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
            label asd
          end
        end


      end
    end
  end

  rails_admin do

    parent AboutPage
    label I18n.t("rails_admin.model_labels.#{self.abstract_model.model_name.underscore}")
    label_plural I18n.t("rails_admin.model_labels_plural.#{self.abstract_model.model_name.underscore}")

    weight -10
    edit do
      field :published do
        if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
          label asd
        end
      end
      field :order_index do
        if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
          label asd
        end
      end
      field :translations, :globalize_tabs do
        if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
          label asd
        end
      end
      group :image_data do
        field :background do
          if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
            label asd
          end
          #versions_info_string = a
          if type == :paperclip
            model = @abstract_model.model_name.constantize
            temp_instance = model.new
            attr = temp_instance.send(method_name)
            help help + ( attr.styles.map{|obj| info = obj[1]; res = {}; res[info.name.to_sym] = info.geometry; res  }).inspect

          end
        end
        field :background_file_name_fallback do
          if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
            label asd
          end
        end
      end
    end
  end
end
