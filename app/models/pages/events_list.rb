class Pages::EventsList < ActiveRecord::Base
  has_one :page_metadata, :class_name => 'VoroninStudio::PageMetadata', as: :page
  attr_accessible :page_metadata

  accepts_nested_attributes_for :page_metadata
  attr_accessible :page_metadata_attributes

  rails_admin do
    navigation_label I18n.t("rails_admin.navigation_labels.pages")
  end
end