# -*- encoding : utf-8 -*-

class Event < ActiveRecord::Base
  #include VoroninStudio::PageHelper

  #acts_as_page
  has_one :page_metadata, :class_name => 'VoroninStudio::PageMetadata', as: :page
  attr_accessible :page_metadata

  accepts_nested_attributes_for :page_metadata
  attr_accessible :page_metadata_attributes

  has_and_belongs_to_many :event_gallery_albums, join_table: :events_and_gallery_albums, :dependent => :destroy

  #has_and_belongs_to_many :event_gallery_images, join_table: :events_and_gallery_images, :dependent => :destroy
  has_many :event_gallery_images

  attr_accessible :event_gallery_albums, :event_gallery_album_id, :event_gallery_album_ids
  attr_accessible :event_gallery_images, :event_gallery_image_id, :event_gallery_image_ids


  accepts_nested_attributes_for :event_gallery_images, :allow_destroy => true
  attr_accessible :event_gallery_images_attributes, :event_gallery_images


  accepts_nested_attributes_for :event_gallery_albums
  attr_accessible :event_gallery_albums_attributes, :event_gallery_albums

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

  has_attached_file :expired_event_avatar, :styles => { expired_event_avatar: '500x1250#' },
                    :url  => "/assets/#{self.name.underscore}/:id/expired_event_avatar/:style/:basename.:extension",
                    :path => ":rails_root/public/assets/#{self.name.underscore}/:id/expired_event_avatar/:style/:basename.:extension",
                    convert_options: {
                        banner: "-quality 94 -interlace Plane",
                    }

  validates_attachment_file_name :avatar, :matches => [/png\Z/i, /jpe?g\Z/i, /gif\Z/i, /svg\Z/i]
  validates_attachment_file_name :banner, :matches => [/png\Z/i, /jpe?g\Z/i, /gif\Z/i, /svg\Z/i]
  validates_attachment_file_name :expired_event_avatar, :matches => [/png\Z/i, /jpe?g\Z/i, /gif\Z/i, /svg\Z/i]

  #acts_as_taggable

  validates_presence_of :start_date



  [:avatar, :banner, :expired_event_avatar].each do |paperclip_field_name|
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
    self.event_subscriptions.where('disabled is null or disabled = "f"').count
  end


  def images
    # query_album_images = "select ai.event_gallery_image_id as 'id' from event_gallery_albums_and_event_gallery_images ai, events_and_gallery_albums ea where ea.event_id = #{self.id} and ai.event_gallery_album_id = ea.event_gallery_album_id "
    # query_event_images = "select ei.event_gallery_image_id as 'id' from events_and_gallery_images ei where ei.event_id = #{self.id}"
    # result_images = EventGalleryImage.find_by_sql(query_album_images) + EventGalleryImage.find_by_sql(query_event_images)
    #
    # image_ids = result_images.map(&:id)
    # image_objects = EventGalleryImage.where(id: image_ids)
    #
    # image_objects
    event_gallery_images
  end

  def tags
    tags_arr = []

    self.event_tags.each do |tag|
      tags_arr.push tag.slug.parameterize.underscore
    end

    tags_arr
  end

  def expired?
    start_date <= DateTime.now

  end

  def up_to_date?
    !expired?
  end

  def enabled_registration?
    disabled_registration != true
  end

  def disabled_by_admin_for_user? user
    subscription = self.event_subscriptions.where(user_id: user.id).first
    return ( subscription ? subscription.disabled : nil )
  end

  attr_accessible :days_and_time_string

  attr_accessible :disabled_registration


  translates :name, :slug, :short_description, :full_description, :address, :days_and_time_string, :versioning => :paper_trail
  accepts_nested_attributes_for :translations
  attr_accessible :translations_attributes, :translations

  class Translation
    attr_accessible :locale, :published_translation, :name, :slug, :short_description, :full_description, :address, :days_and_time_string



    before_validation :fix_slug
    before_save :fix_address

    def fix_address
      self.address = I18n.t("activerecord.defaults.models.event.attributes.address") if !self.address || self.address == ''
    end

    # def fix_slug
    #   locale_was = I18n.locale
    #   temp_locale = locale_was
    #   temp_locale = :ru if I18n.locale == :uk
    #
    #   self.slug = self.name if !self.slug || self.slug == ''
    #
    #   I18n.with_locale(temp_locale) do |locale|
    #     self.slug = self.slug.parameterize
    #   end
    #
    #   self.address = I18n.t("activerecord.defaults.models.event.attributes.address") if !self.address || self.address == ''
    #
    #   #self.participants_count = allowed_subscriptions_count
    # end

    def fix_slug
      locale_was = I18n.locale
      temp_locale = locale_was
      temp_locale = :ru if I18n.locale == :uk

      self.slug = self.name if !self.slug || self.slug == ''

      I18n.with_locale(temp_locale) do |locale|
        self.slug = self.slug.parameterize
      end
    end

    # def published=(value)
    #   self[:published] = value
    # end

    rails_admin do
      visible false

      edit do
        field :locale, :hidden
        #field :published_translation
        field :name do
          if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
            label asd
          end
        end
        field :slug do
          if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
            label asd
          end
        end
        field :address do
          if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
            label asd
          end
        end
        field :short_description do
          if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
            label asd
          end
        end
        field :full_description, :ck_editor do
          if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
            label asd
          end
        end
        field :days_and_time_string, :text do
          if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
            label asd
          end
        end


      end
    end
  end

  # def self.fix_slug
  #   values = {}
  #   field = :slug
  #
  #   self.all.each do |obj|
  #
  #     I18n.available_locales.each do |locale|
  #       if !values.keys.include?(locale.to_sym)
  #         values[locale.to_sym] = []
  #       end
  #       values_for_locale = values[locale.to_sym]
  #       same_values = values_for_locale.select.with_index{|v,i| if v[:value] == obj.translations_by_locale[locale.to_sym].send(field.to_s) then  c = v[:count]; v[:count] = c + 1; t = obj.translations_by_locale[locale.to_sym]; t.send("#{field.to_s}=", "#{v[:value]}-#{v[:count]}"); t.save; end }
  #       if same_values.count == 0
  #         values_for_locale.push( value: obj.translations_by_locale[locale.to_sym].send(field.to_s), count: 1 )
  #
  #       else
  #
  #       end
  #     end
  #   end
  # end


  before_save do
    self.participants_count = allowed_subscriptions_count
  end



  def fix_slug
    self.translations.each do |t|
      t.fix_slug
      t.save
    end
  end

  def self.fix_slug_for_all
    EventTag.all.each do |t|
      t.fix_slug
    end
  end

  validates_with UniqueSlugValidator

  rails_admin do
    weight -10
    navigation_label I18n.t('rails_admin.navigation_labels.events')
    label I18n.t("rails_admin.model_labels.#{self.abstract_model.model_name.underscore}")
    label_plural I18n.t("rails_admin.model_labels_plural.#{self.abstract_model.model_name.underscore}")

    [:start_date, :end_date].each do |f|
      configure f, :date do
        #date_format "%d.%m.%Y"
        strftime_format "%d.%m.%Y"
        #js_plugin_options[:dateFormat] = "dd.mm.yy"
      end
    end

    list do
      field :id do
        if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
          label asd
        end
      end
      field :published do
        if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
          label asd
        end
      end
      field :disabled_registration do
        if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
          label asd
        end
      end
      field :allowed_subscriptions_count do
        if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
          label asd
        end
      end
      field :name do
        if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
          label asd
        end
      end
      field :short_description do
        if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
          label asd
        end
      end
      field :avatar do
        if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
          label asd
        end
      end
      field :start_date do
        if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
          label asd
        end
      end
      field :end_date do
        if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
          label asd
        end
      end
    end

    edit do
      field :published do
        if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
          label asd
        end
      end
      field :disabled_registration do
        if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
          label asd
        end
      end
      field :allowed_subscriptions_count do
        read_only true
        if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
          label asd
        end
      end
      # field :tag_list do
      #   label 'Категорія (може бути декілька)'
      #   help 'Використовуйте кому як розділювач'
      #   partial 'tag_list_with_suggestions'
      # end

      field :translations, :globalize_tabs do
        if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
          label asd
        end
      end
      field :event_tags do
        if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
          label asd
        end
      end




      field :start_date do
        if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
          label asd
        end
      end
      field :end_date do
        if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
          label asd
        end
      end

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


      field :avatar do
        if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
          label asd
        end
        if type == :paperclip
          model = @abstract_model.model_name.constantize
          temp_instance = model.new
          attr = temp_instance.send(method_name)
          help help + ( attr.styles.map{|obj| info = obj[1]; res = {}; res[info.name.to_sym] = info.geometry; res  }).inspect

        end
      end
      field :banner do
        if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
          label asd
        end
        if type == :paperclip
          model = @abstract_model.model_name.constantize
          temp_instance = model.new
          attr = temp_instance.send(method_name)
          help help + ( attr.styles.map{|obj| info = obj[1]; res = {}; res[info.name.to_sym] = info.geometry; res  }).inspect

        end
      end

      field :expired_event_avatar do
        if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
          label asd
        end
        if type == :paperclip
          model = @abstract_model.model_name.constantize
          temp_instance = model.new
          attr = temp_instance.send(method_name)
          help help + ( attr.styles.map{|obj| info = obj[1]; res = {}; res[info.name.to_sym] = info.geometry; res  }).inspect

        end
      end

      field :users do
        label ""
      end

      #field :event_gallery_albums
      field :event_gallery_images do
        if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
          label asd
        end
      end
      field :page_metadata do
        if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
          label asd
        end
      end
    end
  end
end
