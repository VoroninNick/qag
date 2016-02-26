class UserFeedback < ActiveRecord::Base
  belongs_to :home_page
  belongs_to :user

  attr_accessible :home_page

  has_attached_file :avatar, :styles => { thumb: '150x150#', article_list_large_thumb: "690x575#"},
                    :url  => "/assets/#{self.name.underscore}/:id/avatar/:style/:basename.:extension",
                    :path => ":rails_root/public/assets/#{self.name.underscore}/:id/avatar/:style/:basename.:extension",
                    convert_options: {
                        thumb: "-quality 94 -interlace Plane",
                    }

  validates_attachment_file_name :avatar, :matches => [/png\Z/i, /jpe?g\Z/i, /gif\Z/i, /svg\Z/i]

  [:avatar].each do |paperclip_field_name|
    attr_accessible paperclip_field_name.to_sym, "delete_#{paperclip_field_name}".to_sym, "#{paperclip_field_name}_file_name".to_sym, "#{paperclip_field_name}_file_size".to_sym, "#{paperclip_field_name}_content_type".to_sym, "#{paperclip_field_name}_updated_at".to_sym, "#{paperclip_field_name}_file_name_fallback".to_sym, "#{paperclip_field_name}_alt".to_sym

    attr_accessor "delete_#{paperclip_field_name}".to_sym
  end

  attr_accessible :comment_text, :name, :status, :published

  scope :published, -> { where(published: 't') }

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
        if type == :paperclip
          model = @abstract_model.model_name.constantize
          temp_instance = model.new
          attr = temp_instance.send(method_name)
          help help + ( attr.styles.map{|obj| info = obj[1]; res = {}; res[info.name.to_sym] = info.geometry; res  }).inspect

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
