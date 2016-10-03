class UserFeedback < ActiveRecord::Base
  attr_accessible *attribute_names
  belongs_to :home_page
  belongs_to :user

  attr_accessible :home_page

  image :avatar, :styles => { thumb: '150x150#', article_list_large_thumb: "690x575#"},
                    :url  => "/assets/#{self.name.underscore}/:id/avatar/:style/:basename.:extension",
                    :path => ":rails_root/public/assets/#{self.name.underscore}/:id/avatar/:style/:basename.:extension",
                    convert_options: {
                        thumb: "-quality 94 -interlace Plane",
                    }

  attr_accessible :comment_text, :name, :status, :published

  boolean_scope :published
  boolean_scope :featured

  def show_toned_avatar
    true
  end

  def get_avatar
    user
  end

  rails_admin do
    parent HomePage
    weight 3
    label I18n.t("rails_admin.model_labels.#{self.abstract_model.model_name.underscore}")
    label_plural I18n.t("rails_admin.model_labels_plural.#{self.abstract_model.model_name.underscore}")



    edit do
      field :published do
        if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
          label asd
        end
      end
      field :featured do
        if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
          label asd
        end
      end
      field :name do
        if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
          label asd
        end
      end
      field :status do
        if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
          label asd
        end
      end
      field :avatar do
        if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
          label asd
        end

      end
      field :comment_text do
        if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
          label asd
        end
      end
    end
  end
end
