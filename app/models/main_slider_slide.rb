class MainSliderSlide < ActiveRecord::Base
  attr_accessible *attribute_names
  attr_accessible :name, :short_description, :full_description, :published, :order_index

  image :background, :styles => { banner: '2100x1200#', sepia_banner: '2100x1200#' },
                    :url  => "/assets/#{self.name.underscore}/:id/background/:style/:basename.:extension",
                    :path => ":rails_root/public/assets/#{self.name.underscore}/:id/background/:style/:basename.:extension",
                    convert_options: {
                        banner: "-quality 94 -interlace Plane",
                        sepia_banner: "-quality 94 -interlace Plane -fill beige"
                    }




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

  has_cache
  def cache_instances
    arr = []
    arr << HomePage.first if boolean_changed?(:published)

    arr
  end

  rails_admin do
    parent HomePage
    label I18n.t("rails_admin.model_labels.#{self.abstract_model.model_name.underscore}")
    label_plural I18n.t("rails_admin.model_labels_plural.#{self.abstract_model.model_name.underscore}")

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
        field :background, :paperclip do
          if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
            label asd
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
