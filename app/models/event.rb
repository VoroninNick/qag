class Event < ActiveRecord::Base
  has_attached_file :avatar, :styles => { :event_list_small_thumb => '360x240#', :event_list_large_thumb => '720x480#', :home_expired_event_thumb => '400x1000#', :article_item => '320x320>', home_article_item: '250x250>', article_page: '500x500>'},
                    :url  => '/assets/articles/:id/:style/:basename.:extension',
                    :path => ':rails_root/public/assets/articles/:id/:style/:basename.:extension'

  has_attached_file :banner, :styles => { :event_list_small_thumb => '360x240#', :event_list_large_thumb => '720x480#', :home_expired_event_thumb => '400x1000#', :article_item => '320x320>', home_article_item: '250x250>', article_page: '500x500>'},
                    :url  => '/assets/articles/:id/:style/:basename.:extension',
                    :path => ':rails_root/public/assets/articles/:id/:style/:basename.:extension'



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
      edit do
        field :locale, :hidden
        field :published_translation
        field :name
        field :short_description
        field :full, :ck_editor
      end
    end
  end
end
