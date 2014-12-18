class Setting < ActiveRecord::Base
  attr_accessible :social_twitter, :social_facebook, :social_odnoklassniki, :social_linked_in, :social_blogger, :social_vk, :social_google_plus

  def self.get_social_links
    settings = Setting.first
    result = {}

    [:twitter, :facebook, :odnoklassniki, :linked_in, :blogger, :vk, :google_plus].each do |field_name|
      value = settings.send("social_#{field_name}")
      if value && value.length > 0
        result[field_name] = value
      end
    end

    result
  end

  rails_admin do
    label I18n.t("rails_admin.model_labels.#{self.abstract_model.model_name.underscore}")
    label_plural I18n.t("rails_admin.model_labels_plural.#{self.abstract_model.model_name.underscore}")

    group :social_links do
      field :social_twitter
      field :social_facebook
      field :social_odnoklassniki
      field :social_linked_in
      field :social_blogger
      field :social_vk
      field :social_google_plus
    end
  end
end
