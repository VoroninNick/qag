class AboutPageSliderSlide < ActiveRecord::Base
  attr_accessible *attribute_names

  image :background, :styles => { banner: '2100x650#', bw_banner: '2100x650#', sepia_banner: '2100x1200#' },
                    :url  => "/assets/#{self.name.underscore}/:id/background/:style/:basename.:extension",
                    :path => ":rails_root/public/assets/#{self.name.underscore}/:id/background/:style/:basename.:extension",
                    convert_options: {
                        banner: "-quality 94 -interlace Plane",
                        sepia_banner: "-quality 94 -interlace Plane -fill beige",
                        :bw_banner => '-quality 94 -interlace Plane -colorspace Gray'
                    }



  boolean_scope :published
  scope :sort_by_sorting_position, -> { order("sorting_position asc") }



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
    nestable_list(position_field: :sorting_position)
    parent AboutPage
    initialize_model_label


    weight -10
    edit do
      field :published
      field :translations, :globalize_tabs
      group :image_data do
        field :background
        field :background_file_name_fallback
      end
    end
  end
end
