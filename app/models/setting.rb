class Setting < ActiveRecord::Base
  attr_accessible *attribute_names

  def self.get_social_links
    settings = Setting.first
    result = {}
    #keys = [:twitter, :facebook, :odnoklassniki, :linked_in, :blogger, :vk, :google_plus]
    keys = [:twitter, :facebook, :linked_in, :vk, :google_plus]
    keys.each do |field_name|
      value = settings.send("social_#{field_name}")
      if value && value.length > 0
        result[field_name] = value
      end
    end

    result
  end

  def self.get_share_links(object = nil, url = nil, title = nil)
    if object
      url = Rails.application.routes.url_helpers.url_for(object) if url.blank?
      title = object.try(:title) if title.blank?
      title = object.try(:name) if title.blank?
    elsif url.blank? || title.blank?
      raise StandardError, "Setting#get_share_links: please provide url and title"
    end
    host = Rails.application.config.action_mailer.default_url_options[:host]
    full_url = "#{host}#{url}"
    settings = Setting.first
    result = {}
    keys = [:twitter, :facebook, :linked_in, :vk, :google_plus]
    keys.each do |field_name|
      value = self.send("get_#{field_name}_share_link", full_url, title)
      if value && value.length > 0
        result[field_name] = value
      end
    end

    result
  end

  def self.get_facebook_share_link(url, title)
    "http://www.facebook.com/sharer/sharer.php?u=#{url}&title=#{title}"
  end

  def self.get_twitter_share_link(url, title)
    "http://twitter.com/intent/tweet?status=#{title}+#{url}"
  end

  def self.get_linked_in_share_link(url, title)
    "http://www.linkedin.com/shareArticle?mini=true&url=#{url}&title=#{title}&source=[SOURCE/DOMAIN]"
  end

  def self.get_vk_share_link(url, title = nil)
    "http://vk.com/share.php?url=#{url}"
  end

  def self.get_google_plus_share_link(url, title = nil)
    "https://plus.google.com/share?url=#{url}"
  end

  rails_admin do
    other_navigation_label
    label I18n.t("rails_admin.model_labels.#{self.abstract_model.model_name.underscore}")
    label_plural I18n.t("rails_admin.model_labels_plural.#{self.abstract_model.model_name.underscore}")

    group :sitemap_settings do

    end

    group :social_links do
      field :social_twitter
      field :social_facebook
      field :social_odnoklassniki
      field :social_linked_in
      field :social_blogger
      field :social_vk
      field :social_google_plus
    end
  end
end
