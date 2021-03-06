class EventTag < ActiveRecord::Base

  has_and_belongs_to_many :events, join_table: :event_taggings
  attr_accessible :events, :event_id, :event_ids

  translates :name, :slug, :versioning => :paper_trail
  accepts_nested_attributes_for :translations
  attr_accessible :translations_attributes, :translations

  class Translation
    attr_accessible :locale, :published_translation, :name, :slug, :short_description, :full_description

    # def published=(value)
    #   self[:published] = value
    # end

    rails_admin do
      visible false

      edit do
        field :locale, :hidden
        field :name
        field :slug
      end
    end
  end

  rails_admin do
    navigation_label "Events"

    edit do
      field :translations, :globalize_tabs
      field :events
    end
  end
end
