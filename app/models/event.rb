# -*- encoding : utf-8 -*-

class Event < ActiveRecord::Base

  has_and_belongs_to_many :event_gallery_albums, join_table: :events_and_gallery_albums

  has_and_belongs_to_many :event_gallery_images, join_table: :events_and_gallery_images

  attr_accessible :event_gallery_albums, :event_gallery_album_id, :event_gallery_album_ids
  attr_accessible :event_gallery_images, :event_gallery_image_id, :event_gallery_image_ids

  has_and_belongs_to_many :event_tags, join_table: :event_taggings
  attr_accessible :event_tags, :event_tag_id, :event_tag_ids


  has_attached_file :avatar, :styles => { :event_list_small_thumb => '360x240#', :event_list_avatar => '255x170#', :event_list_large_thumb => '720x480#', :home_expired_event_thumb => '500x1250#', :article_item => '320x320>', home_article_item: '250x250>', article_page: '500x500>'},
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

  #acts_as_taggable



  [:avatar, :banner].each do |paperclip_field_name|
    attr_accessible paperclip_field_name.to_sym, "delete_#{paperclip_field_name}".to_sym, "#{paperclip_field_name}_file_name".to_sym, "#{paperclip_field_name}_file_size".to_sym, "#{paperclip_field_name}_content_type".to_sym, "#{paperclip_field_name}_updated_at".to_sym, "#{paperclip_field_name}_file_name_fallback".to_sym, "#{paperclip_field_name}_alt".to_sym

    attr_accessor "delete_#{paperclip_field_name}".to_sym
  end

  #has_and_belongs_to_many :users, join_table: 'event_subscriptions'
  has_many :event_subscriptions
  has_many :users, through: :event_subscriptions

  attr_accessible :published, :name, :slug, :short_description, :full_description

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

  attr_accessible :registration_enabled

  def allowed_subscriptions_count
    #variable_name = "@event_#{id}_allowed_subscriptions_count"
    #return instance_variable_get(variable_name) if instance_variable_defined?(variable_name)

    #return instance_variable_set(variable_name, self.event_subscriptions.where(disabled: false).count)
    self.event_subscriptions.where(disabled: false).count
  end


  def images
    query_album_images = "select ai.event_gallery_image_id as 'id' from event_gallery_albums_and_event_gallery_images ai, events_and_gallery_albums ea where ea.event_id = #{self.id} and ai.event_gallery_album_id = ea.event_gallery_album_id "
    query_event_images = "select ei.event_gallery_image_id as 'id' from events_and_gallery_images ei where ei.event_id = #{self.id}"
    result_images = EventGalleryImage.find_by_sql(query_album_images) + EventGalleryImage.find_by_sql(query_event_images)

    image_ids = result_images.map(&:id)
    image_objects = EventGalleryImage.where(id: image_ids)

    image_objects
  end

  def tags
    tags_arr = []

    self.event_tags.each do |tag|
      tags_arr.push tag.slug.parameterize.underscore
    end

    tags_arr
  end

  def expired?
    end_date <= DateTime.now
  end

  def up_to_date?
    !expired?
  end

  def enabled_registration?
    disabled_registration != true
  end

  attr_accessible :days_and_time_string

  attr_accessible :disabled_registration


  translates :name, :slug, :short_description, :full_description, :address, :days_and_time_string, :versioning => :paper_trail
  accepts_nested_attributes_for :translations
  attr_accessible :translations_attributes, :translations

  class Translation
    attr_accessible :locale, :published_translation, :name, :slug, :short_description, :full_description, :address, :days_and_time_string

    before_save do
      self.slug = self.name.parameterize if !self.slug || self.slug == ''
      self.slug = self.slug.parameterize.underscore

      #self.participants_count = allowed_subscriptions_count
    end

    # def published=(value)
    #   self[:published] = value
    # end

    rails_admin do
      visible false

      edit do
        field :locale, :hidden
        field :published_translation
        field :name
        field :slug do
          label "url"
        end
        field :address
        field :short_description
        field :full_description, :ck_editor
        field :days_and_time_string, :text


      end
    end
  end

  def self.fix_slug
    values = {}
    field = :slug

    self.all.each do |obj|

      I18n.available_locales.each do |locale|
        if !values.keys.include?(locale.to_sym)
          values[locale.to_sym] = []
        end
        values_for_locale = values[locale.to_sym]
        same_values = values_for_locale.select.with_index{|v,i| if v[:value] == obj.translations_by_locale[locale.to_sym].send(field.to_s) then  c = v[:count]; v[:count] = c + 1; t = obj.translations_by_locale[locale.to_sym]; t.send("#{field.to_s}=", "#{v[:value]}-#{v[:count]}"); t.save; end }
        if same_values.count == 0
          values_for_locale.push( value: obj.translations_by_locale[locale.to_sym].send(field.to_s), count: 1 )

        else

        end
      end
    end
  end


  before_save do
    self.participants_count = allowed_subscriptions_count
  end

  validates_with UniqueSlugValidator

  rails_admin do
    weight -2
    navigation_label "Events"

    [:start_date, :end_date].each do |f|
      configure f, :date do
        #date_format "%d.%m.%Y"
        strftime_format "%d.%m.%Y"
        #js_plugin_options[:dateFormat] = "dd.mm.yy"
      end
    end

    list do
      field :id
      field :published
      field :disabled_registration
      field :name
      field :short_description
      field :avatar
      field :start_date
      field :end_date
    end

    edit do
      field :published
      field :disabled_registration
      field :participants_count do
        read_only true
      end
      # field :tag_list do
      #   label 'Категорія (може бути декілька)'
      #   help 'Використовуйте кому як розділювач'
      #   partial 'tag_list_with_suggestions'
      # end

      field :translations, :globalize_tabs
      field :event_tags




      field :start_date
      field :end_date

      group :days do
        hide

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


      field :avatar
      field :banner

      field :event_gallery_albums
      field :event_gallery_images
    end
  end
end
