#ActsAsTaggableOn::Tag.class_eval do
  #translates :name, :versioning => :paper_trail
  #
  # accepts_nested_attributes_for :translations
  # attr_accessible :translations_attributes, :translations
  #
  # class Translation
  #   attr_accessible :locale, :name
  #
  #   # def published=(value)
  #   #   self[:published] = value
  #   # end
  #
  #   rails_admin do
  #     visible false
  #
  #     edit do
  #       field :locale, :hidden
  #       field :name
  #     end
  #   end
  # end
  #
  # rails_admin do
  #   edit do
  #     field :taggings_count
  #     field :taggings
  #     field :translations, :globalize_tags
  #   end
  # end
#end