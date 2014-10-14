class Event < ActiveRecord::Base
  has_attached_file :avatar, :styles => { :event_list_small_thumb => '360x240#', :event_list_large_thumb => '720x480#', :home_expired_event_thumb => '500x1250#', :article_item => '320x320>', home_article_item: '250x250>', article_page: '500x500>'},
                    :url  => "/assets/#{self.name.underscore}/:id/avatar/:style/:basename.:extension",
                    :path => ":rails_root/public/assets/#{self.name.underscore}/:id/avatar/:style/:basename.:extension",
                    convert_options: {
                        banner: "-quality 94 -interlace Plane",
                    }

  has_attached_file :banner, :styles => { banner: '2100x500#' },
                    :url  => "/assets/#{self.name.underscore}/:id/banner/:style/:basename.:extension",
                    :path => ":rails_root/public/assets/#{self.name.underscore}/:id/banner/:style/:basename.:extension",
                    convert_options: {
                        banner: "-quality 94 -interlace Plane",
                    }

  validates_attachment_file_name :avatar, :matches => [/png\Z/i, /jpe?g\Z/i, /gif\Z/i, /svg\Z/i]
  validates_attachment_file_name :banner, :matches => [/png\Z/i, /jpe?g\Z/i, /gif\Z/i, /svg\Z/i]



  [:avatar, :banner].each do |paperclip_field_name|
    attr_accessible paperclip_field_name.to_sym, "delete_#{paperclip_field_name}".to_sym, "#{paperclip_field_name}_file_name".to_sym, "#{paperclip_field_name}_file_size".to_sym, "#{paperclip_field_name}_content_type".to_sym, "#{paperclip_field_name}_updated_at".to_sym, "#{paperclip_field_name}_file_name_fallback".to_sym, "#{paperclip_field_name}_alt".to_sym

    attr_accessor "delete_#{paperclip_field_name}".to_sym
  end

  has_and_belongs_to_many :users, join_table: 'event_subscriptions'


  attr_accessible :published, :name, :short_description, :full_description

  attr_accessible :start_date, :end_date, :address, :participants_count

  attr_accessible :day_monday,
    :day_monday_start_time,
    :day_tuesday,
    :day_tuesday_start_time,
    :day_wensday,
    :day_wensday_start_time,
    :day_thursday,
    :day_thursday_start_time,
    :day_friday,
    :day_friday_start_time,
    :day_saturday,
    :day_saturday_start_time,
    :day_sunday,
    :day_sunday_start_time


  translates :name, :short_description, :full_description, :address, :versioning => :paper_trail
  accepts_nested_attributes_for :translations
  attr_accessible :translations_attributes, :translations

  class Translation
    attr_accessible :locale, :published_translation, :name, :short_description, :full_description, :address

    # def published=(value)
    #   self[:published] = value
    # end

    rails_admin do
      visible false

      edit do
        field :locale, :hidden
        field :published_translation
        field :name
        field :address
        field :short_description
        field :full_description, :ck_editor


      end
    end
  end

  rails_admin do
    weight -2

    edit do
      field :published

      field :translations, :globalize_tabs


      field :start_date
      field :end_date

      group :days do
        field :day_monday
        field :day_monday_start_time
        field :day_tuesday
        field :day_tuesday_start_time
        field :day_wensday
        field :day_wensday_start_time
        field :day_thursday
        field :day_thursday_start_time
        field :day_friday
        field :day_friday_start_time
        field :day_saturday
        field :day_saturday_start_time
        field :day_sunday
        field :day_sunday_start_time
      end


      field :participants_count

      field :avatar
      field :banner
    end
  end
end
