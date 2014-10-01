class HomeAboutUsSlide < ActiveRecord::Base
  attr_accessible :name, :short_description, :full_description, :published, :order_index

  translates :name, :short_description, :full_description, :versioning => :paper_trail
  accepts_nested_attributes_for :translations
  attr_accessible :translations_attributes, :translations

  class Translation
    attr_accessible :locale, :published_translation, :name, :short_description, :full_description

    # def published=(value)
    #   self[:published] = value
    # end

    rails_admin do
      visible false

      edit do
        field :locale, :hidden
        field :published_translation
        field :name
        field :short_description
        field :full_description, :ck_editor
      end
    end
  end

  rails_admin do
    parent HomePage

    edit do
      field :published
      field :order_index
      field :translations, :globalize_tabs

    end
  end
end
