class Article < ActiveRecord::Base
  attr_accessible :published, :name, :short_description, :full_description, :release_date

  has_attached_file :avatar, :styles => { :article_list_small_thumb => '360x300#', related_irticle_thumb: '600x500#'},
                    :url  => '/assets/articles/:id/:style/:basename.:extension',
                    :path => ':rails_root/public/assets/articles/:id/:style/:basename.:extension',
                    convert_options: {
                      article_list_small_thumb: "-quality 94 -interlace Plane",
                      related_irticle_thumb: "-quality 94 -interlace Plane"
                    }

  has_attached_file :banner, :styles => { :banner => '2100x500#'},
                    :url  => '/assets/articles/:id/:style/:basename.:extension',
                    :path => ':rails_root/public/assets/articles/:id/:style/:basename.:extension',
                    convert_options: {
                        banner: "-quality 94 -interlace Plane",
                    }


  [:avatar, :banner].each do |paperclip_field_name|
    attr_accessible paperclip_field_name.to_sym, "delete_#{paperclip_field_name}".to_sym, "#{paperclip_field_name}_file_name".to_sym, "#{paperclip_field_name}_file_size".to_sym, "#{paperclip_field_name}_content_type".to_sym, "#{paperclip_field_name}_updated_at".to_sym, "#{paperclip_field_name}_file_name_fallback".to_sym, "#{paperclip_field_name}_alt".to_sym

    attr_accessor "delete_#{paperclip_field_name}".to_sym
  end

  translates :name, :short_description, :full_description, :avatar_alt, :banner_alt, :versioning => :paper_trail
  accepts_nested_attributes_for :translations
  attr_accessible :translations_attributes, :translations

  class Translation
    attr_accessible :locale, :published_translation, :name, :short_description, :full_description, :address

    # def published=(value)
    #   self[:published] = value
    # end

    rails_admin do
      edit do
        field :locale, :hidden
        field :published_translation

      end
    end
  end
end
