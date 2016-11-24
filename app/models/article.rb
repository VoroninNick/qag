class Article < ActiveRecord::Base
  attr_accessible *attribute_names

  has_seo_tags
  has_sitemap_record
  has_aliases
  image :avatar, :styles => { :article_list_small_thumb => '360x300#', related_irticle_thumb: '600x500#', :article_list_large_thumb => "690x575#"},
                    :url  => "/uploads/#{self.name.underscore}/:id/avatar/:style/:basename.:extension",
                    :path => ":rails_root/public:url",
                    convert_options: {
                      article_list_small_thumb: "-quality 94 -interlace Plane",
                      related_irticle_thumb: "-quality 94 -interlace Plane",
                      article_list_large_thumb: "-quality 94 -interlace Plane"
                    }

  image :banner, :styles => { :banner => '2100x500#'},
                    :url  => "/uploads/#{self.name.underscore}/:id/banner/:style/:basename.:extension",
                    :path => ":rails_root/public:url",
                    convert_options: {
                        banner: "-quality 94 -interlace Plane",
                    }

  validates :name, presence: true
  validates :url_fragment, presence: true, uniqueness: true

  attr_accessible :show_toned_avatar, :show_toned_banner

  boolean_scope :published

  translates :name, :url_fragment, :short_description, :full_description, :avatar_alt, :banner_alt, :versioning => :paper_trail
  accepts_nested_attributes_for :translations, allow_destroy: true
  attr_accessible :translations_attributes, :translations

  has_cache
  def url(*args)
    "/articles/#{url_fragment}"
  end

  def cache_instances
    #articles = related_articles.to_a + old_related_articles.to_a

    arr = [Article.published, Pages::ArticlesList.first.url, "ajax/articles/page/*", "articles/page/*"]
    arr << self if boolean_changed?(:published) || published

    arr
  end

  def related_articles
    Article.published.where.not(id: self.id).order('updated_at desc').limit(4)
  end

  def old_related_articles
    []
  end

  def self.default_priority
    0.9
  end

  class Translation
    attr_accessible :locale, :url_fragment, :published_translation, :name, :short_description, :full_description

    before_validation :fix_slug

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
        field :avatar_alt do
          if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
            label asd
          end
        end
        field :banner_alt do
          if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
            label asd
          end
        end

      end
    end
  end

  def fix_slug
    self.translations.each do |t|
      t.fix_slug
      #t.save
    end
  end

  def self.fix_slug_for_all
    EventTag.all.each do |t|
      t.fix_slug
    end
  end

  before_validation :fix_slug

  validates_with UniqueSlugValidator


  rails_admin do
    navigation_label I18n.t('rails_admin.navigation_labels.articles')
    label I18n.t("rails_admin.model_labels.#{self.abstract_model.model_name.underscore}")
    label_plural I18n.t("rails_admin.model_labels_plural.#{self.abstract_model.model_name.underscore}")
    # [:published, :translations, :avatar, :banner, :page_metadata].each do |field_name|
    #   configure field_name do
    #     label I18n.t("rails_admin.field_labels.#{field_name}")
    #   end
    # end
    weight -10

    edit do
      field :published do
        #label get_field_label(self)
        #label get_field_label
        if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
          label asd
        end

      end
      field :translations, :globalize_tabs do
        if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
          label asd
        end
      end
      field :avatar do
        if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
          label asd
        end
      end

      field :show_toned_avatar
      #field :avatar_file_name_fallback

      field :banner do
        if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
          label asd
        end
      end

      field :show_toned_banner

      #field :banner_file_name_fallback
      field :seo_tags
      field :sitemap_record
    end
  end
end
