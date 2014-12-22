class ContactPage < ActiveRecord::Base
  has_one :page_metadata, :class_name => 'VoroninStudio::PageMetadata', as: :page
  attr_accessible :page_metadata

  accepts_nested_attributes_for :page_metadata
  attr_accessible :page_metadata_attributes

  attr_accessible :content

  rails_admin do
    navigation_label I18n.t("rails_admin.navigation_labels.pages")
    label I18n.t("rails_admin.model_labels.#{self.abstract_model.model_name.underscore}")
    label_plural I18n.t("rails_admin.model_labels_plural.#{self.abstract_model.model_name.underscore}")
    weight 3

    edit do
      field :content, :ck_editor
      field :page_metadata
    end
  end
end
