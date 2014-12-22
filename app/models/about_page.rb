class AboutPage < ActiveRecord::Base
  def slider_slides
    AboutPageSliderSlide.all
    #"hello"

  end

  has_many :about_page_slider_slides
  has_many :team_members
  has_many :participants

  [:about_page_slider_slides, :team_members, :participants].each do |a|
    accepts_nested_attributes_for a, allow_destroy: true
    attr_accessible a, "#{a}_attributes".to_sym
  end

  has_one :page_metadata, :class_name => 'VoroninStudio::PageMetadata', as: :page
  attr_accessible :page_metadata

  accepts_nested_attributes_for :page_metadata
  attr_accessible :page_metadata_attributes

  attr_accessible :top_text, :quote, :bottom_text, :team_text, :participants_text

  has_attached_file :banner, :styles => { :banner => '2100x500#'},
                    :url  => "/assets/#{self.name.underscore}/:id/banner/:style/:basename.:extension",
                    :path => ":rails_root/public/assets/#{self.name.underscore}/:id/banner/:style/:basename.:extension",
                    convert_options: {
                        banner: "-quality 94 -interlace Plane",
                    }

  validates_attachment_file_name :banner, :matches => [/png\Z/i, /jpe?g\Z/i, /gif\Z/i, /svg\Z/i]

  [:banner].each do |paperclip_field_name|
    attr_accessible paperclip_field_name.to_sym, "delete_#{paperclip_field_name}".to_sym, "#{paperclip_field_name}_file_name".to_sym, "#{paperclip_field_name}_file_size".to_sym, "#{paperclip_field_name}_content_type".to_sym, "#{paperclip_field_name}_updated_at".to_sym, "#{paperclip_field_name}_file_name_fallback".to_sym, "#{paperclip_field_name}_alt".to_sym

    attr_accessor "delete_#{paperclip_field_name}".to_sym
  end


  #has_one :authors

  #accepts_nested_attributes_for :slider_slides
  #attr_accessible :slider_slides, :slider_slides_attributes
  rails_admin do
    #field :slider_slides#, :has_many_association
    navigation_label I18n.t("rails_admin.navigation_labels.pages")
    label I18n.t("rails_admin.model_labels.#{self.abstract_model.model_name.underscore}")
    label_plural I18n.t("rails_admin.model_labels_plural.#{self.abstract_model.model_name.underscore}")
    #field :authors
    field :banner do
      if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
        label asd
      end
      if type == :paperclip
        model = @abstract_model.model_name.constantize
        temp_instance = model.new
        attr = temp_instance.send(method_name)
        help help + ( attr.styles.map{|obj| info = obj[1]; res = {}; res[info.name.to_sym] = info.geometry; res  }).inspect
      end
    end

    field :top_text, :ck_editor do
      if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
        label asd
      end
    end
    field :quote do
      if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
        label asd
      end
    end
    field :about_page_slider_slides do
      if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
        label asd
      end
    end
    field :bottom_text, :ck_editor do
      if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
        label asd
      end
    end
    field :team_text, :ck_editor do
      if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
        label asd
      end
    end
    field :team_members do
      if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
        label asd
      end
    end
    field :participants_text, :ck_editor do
      if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
        label asd
      end
    end
    field :participants do
      if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
        label asd
      end
    end
    field :page_metadata do
      if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
        label asd
      end
    end


  end
end
