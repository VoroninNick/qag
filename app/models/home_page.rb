class HomePage < ActiveRecord::Base
  attr_accessible *attribute_names

  has_many :home_about_us_slides
  has_many :home_contact_infos
  #has_many :comments, as: :commentable
  has_many :user_feedbacks
  has_many :main_slider_slides

  has_seo_tags

  accepts_nested_attributes_for :home_about_us_slides, allow_destroy: true
  attr_accessible :home_about_us_slides_attributes, :home_about_us_slides

  accepts_nested_attributes_for :home_contact_infos
  attr_accessible :home_contact_infos_attributes, :home_contact_infos

  #accepts_nested_attributes_for :comments
  #attr_accessible :comments_attributes, :comments
  accepts_nested_attributes_for :user_feedbacks, allow_destroy: true
  attr_accessible :user_feedbacks, :user_feedbacks_attributes

  accepts_nested_attributes_for :main_slider_slides, allow_destroy: true
  attr_accessible :main_slider_slides_attributes, :main_slider_slides

  has_cache
  def url(*args)
    "/"
  end


  rails_admin do
    weight -100
    navigation_label I18n.t("rails_admin.navigation_labels.pages")
    label I18n.t("rails_admin.model_labels.#{self.abstract_model.model_name.underscore}")
    label_plural I18n.t("rails_admin.model_labels_plural.#{self.abstract_model.model_name.underscore}")
    edit do
      field :main_slider_slides do
        if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
          label asd
        end
      end
      #field :home_about_us_slides
      field :home_contact_infos do
        if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
          label asd
        end
      end
      # field :comments do
      #   if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
      #     label asd
      #   end
      # end

      field :user_feedbacks do
        if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
          label asd
        end
      end

      field :seo_tags
    end
  end

end
