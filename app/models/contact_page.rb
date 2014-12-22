class ContactPage < ActiveRecord::Base
  has_one :page_metadata, :class_name => 'VoroninStudio::PageMetadata', as: :page
  attr_accessible :page_metadata

  accepts_nested_attributes_for :page_metadata
  attr_accessible :page_metadata_attributes

  attr_accessible :content

  rails_admin do
    edit do
      field :content
      field :page_metadata
    end
  end
end
