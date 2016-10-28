# -*- encoding : utf-8 -*-

class Event < ActiveRecord::Base
  attr_accessible *attribute_names
  include Enumerize
  #include VoroninStudio::PageHelper

  has_seo_tags

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

  enumerize :event_type, in: [:event, :course], default: :event

  scope "events", -> { where(event_type: "event")  }
  scope "courses", -> { where(event_type: "course")  }

  def event?
    event_type == "event"
  end

  def course?
    event_type == "course"
  end

  def show_participants_count?
    event?
  end

  image :avatar, :styles => { :event_list_small_thumb => '360x240#', :event_list_avatar => '255x170#', :event_list_large_thumb => '720x480#', :home_expired_event_thumb => '500x1250#', :article_item => '320x320>', home_article_item: '250x250>', article_page: '500x500>'},
                    :url  => "/assets/#{self.name.underscore}/:id/avatar/:style/:basename.:extension",
                    :path => ":rails_root/public/assets/#{self.name.underscore}/:id/avatar/:style/:basename.:extension",
                    convert_options: {
                        banner: "-quality 94 -interlace Plane",
                    }

  image :banner, :styles => { banner: '2100x500#' },
                    :url  => "/assets/#{self.name.underscore}/:id/banner/:style/:basename.:extension",
                    :path => ":rails_root/public/assets/#{self.name.underscore}/:id/banner/:style/:basename.:extension",
                    convert_options: {
                        banner: "-quality 94 -interlace Plane",
                    }

  image :expired_event_avatar, :styles => { expired_event_avatar: '500x1250#' },
                    :url  => "/assets/#{self.name.underscore}/:id/expired_event_avatar/:style/:basename.:extension",
                    :path => ":rails_root/public/assets/#{self.name.underscore}/:id/expired_event_avatar/:style/:basename.:extension",
                    convert_options: {
                        banner: "-quality 94 -interlace Plane",
                    }


  validates_presence_of :start_date





  #has_and_belongs_to_many :users, join_table: 'event_subscriptions'
  has_many :event_subscriptions
  has_many :users, through: :event_subscriptions

  attr_accessible :users, :user_ids

  attr_accessible :published, :name, :url_fragment, :short_description, :full_description

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

  boolean_scope :published

  has_cache
  def cache_instances
    self_id = self.try(:id)
    arr = [self, HomePage.first, Object.const_get("Pages::#{event_type.pluralize.capitalize}List").first, "ajax/#{event_type.pluralize}/page/*", "#{event_type.pluralize}/page/*"]
    arr << cache_path("/home/event_info/#{self_id}") if self_id.present?

    arr
  end

  def url(locale = I18n.locale)
    "/#{event_type}/#{url_fragment}"
  end

  def allowed_subscriptions_count
    self.event_subscriptions.allowed_subscriptions.count
  end

  def disallowed_subscriptions_count
    self.event_subscriptions.disallowed_subscriptions.count
  end

  def user_subscriptions_count
    event_subscriptions.user_subscriptions.count
  end

  def anonymous_subscriptions_count
    event_subscriptions.count - user_subscriptions_count
  end


  def images
    event_gallery_images
  end

  def tags
    tags_arr = []

    self.event_tags.each do |tag|
      tags_arr.push tag.url_fragment.parameterize.underscore
    end

    tags_arr
  end

  def event_expired?
    if self.end_date
      self.end_date < Date.today
    else
      start_date < Date.today
    end
  end

  def up_to_date?
    !event_expired?
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


  translates :name, :url_fragment, :short_description, :full_description, :address, :days_and_time_string, :versioning => :paper_trail
  accepts_nested_attributes_for :translations
  attr_accessible :translations_attributes, :translations

  class Translation
    attr_accessible *attribute_names
    attr_accessible :locale, :published_translation, :name, :url_fragment, :short_description, :full_description, :address, :days_and_time_string



    before_validation :fix_slug
    before_save :fix_address

    def fix_address
      #self.address = I18n.t("activerecord.defaults.models.event.attributes.address") if !self.address || self.address == ''
    end

    def fix_slug
      locale_was = I18n.locale
      temp_locale = locale_was
      temp_locale = :ru if I18n.locale == :uk

      self.url_fragment = self.name if !self.url_fragment || self.url_fragment == ''

      I18n.with_locale(temp_locale) do |locale|
        self.url_fragment = self.url_fragment.parameterize
      end
    end


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
        field :url_fragment do
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

    configure :event_type, :enum do |f|
      if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
        label asd
      end
    end

    [:start_date, :end_date].each do |f|
      configure f, :date do
        #date_format "%d.%m.%Y"
        strftime_format "%d.%m.%Y"
        #js_plugin_options[:dateFormat] = "dd.mm.yy"
      end
    end

    configure :published do
      if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
        label asd
      end
    end
    configure :disabled_registration do
      if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
        label asd
      end
    end
    configure :allowed_subscriptions_count do
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

    configure :translations, :globalize_tabs do
      if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
        label asd
      end
    end
    configure :event_tags do
      if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
        label asd
      end
    end




    configure :start_date do
      if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
        label asd
      end
    end
    configure :end_date do
      if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
        label asd
      end

      help "якщо це курс, залишайте порожнім"
    end

    configure :avatar do
      if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
        label asd
      end
    end
    configure :banner do
      if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
        label asd
      end
    end

    configure :expired_event_avatar do
      if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
        label asd
      end
    end

    configure :users

    #field :event_gallery_albums
    configure :event_gallery_images do
      if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
        label asd
      end
    end


    list do
      field :event_type
      field :published
      field :disabled_registration
      field :allowed_subscriptions_count
      field :name
      #field :short_description
      #field :avatar
      field :start_date
      field :end_date
    end



    edit do
      group :registration_details do
        field :disabled_registration
        #field :allowed_subscriptions_count
        #field :users
        field :event_subscriptions do
          partial "event_subscriptions"
        end
      end

      group :details do
        field :event_type
        field :published
        field :translations, :globalize_tabs
        field :event_tags
        field :start_date do
          date_format do
            :default
          end
        end
        field :end_date do
          date_format do
            :default
          end
        end
        field :avatar
        field :banner
        #field :expired_event_avatar
        field :event_gallery_images
        field :seo_tags
      end
    end

    show do
      field :published
      field :name
      field :start_date
      field :end_date
      field :address
      field :days_and_time_string
      field :event_subscriptions
      field :users
      field :allowed_subscriptions_count
    end
  end
end
