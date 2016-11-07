def pages_models
  Dir[Rails.root.join("app/models/pages/*")].map{|p| filename = File.basename(p, ".rb"); "Pages::" + filename.camelize }
end

def templates_models
  Dir[Rails.root.join("app/models/templates/*")].map{|p| filename = File.basename(p, ".rb"); "Templates::" + filename.camelize }
end

def include_pages_models(config)
  include_models(config, *pages_models)
end

def include_templates_models(config)
  include_models(config, *templates_models)
end

def include_models(config, *models)
  models.each do |model|
    config.included_models += [model]

    if !model.instance_of?(Class)
      Dir[Rails.root.join("app/models/#{model.underscore}")].each do |file_name|
        require file_name
      end

      model = model.constantize rescue nil
    end

    if model.respond_to?(:translates?) && model.translates?
      config.included_models += [model.translation_class]
    end
  end
end

def content_field(name = :content, editor = :code_mirror)
  field_type = :text
  field_type = :ck_editor if editor == :ck_editor
  field name, field_type do
    help "Якщо редактор не відображається, обновіть сторінку"
    if editor == :code_mirror
      html_attributes do
        {
            class: "my-codemirror",
            mode: "slim"
        }
      end
    end

    def value
      bindings[:object].send(name.to_s)
    end
  end
end

def ckeditor_field name = :content, &block
  field name, :ck_editor, &block
end

def initialize_model_label
  label I18n.t("rails_admin.model_labels.#{self.abstract_model.model_name.underscore}")
  label_plural do
    str = I18n.t("rails_admin.model_labels_plural.#{self.abstract_model.model_name.underscore}", raise: true) rescue nil
    str = I18n.t("rails_admin.model_labels.#{self.abstract_model.model_name.underscore}") if str.blank?

    str
  end
end

def initialize_field_label
  if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
    label asd
  end
end

def pages_navigation_label
  navigation_label do
    I18n.t("rails_admin.navigation_labels.pages")
  end
end

def settings_navigation_label
  navigation_label do
    "Налаштування"
  end
end

def forms_navigation_label
  navigation_label do
    "Forms"
  end
end

def other_navigation_label
  navigation_label do
    I18n.t('rails_admin.navigation_labels.other')
  end
end

def page_fields(hide_content = false)
  #configure_codemirror_html_field(:content)
  field :banner
  content_field  if !hide_content


  html_block_fields
  field :url
  field :seo_tags
  field :sitemap_record
end

def configure_codemirror_html_field(name)
  configure name, :code_mirror do
    theme = "night" # night
    mode = 'css'

    assets do
      {
          mode: "/assets/codemirror/modes/#{mode}.js",
          theme: "/assets/codemirror/themes/#{theme}.css",
      }
    end

    config do
      {
          mode: mode,
          theme: theme,
      }
    end
  end
end

def configure_html_blocks
  m = self.abstract_model.model
  if m.respond_to?(:html_block_field_names)

    m.html_block_field_names.each do |name|

    end
  end
end

def html_block_fields
  m = self.abstract_model.model
  if m.respond_to?(:html_block_field_names)

    m.html_block_field_names.each do |name|
      content_field name.to_sym
    end
  end
end

def attachment_field(name)
  field name, :paperclip
end

module RailsAdminDynamicConfig
  class << self
    def configure_rails_admin(initial = true)
      RailsAdmin.config do |config|
        if initial
          config.actions do
            dashboard                     # mandatory
            index                         # mandatory
            new
            export
            bulk_delete
            show
            edit
            delete
            show_in_app

            ## With an audit adapter, you can add:
            history_index
            history_show

            nestable do
              only [Participant, TeamMember, AboutPageSliderSlide]
            end
          end

          ## == Devise ==
          config.authenticate_with do
            warden.authenticate! scope: :user
          end
          config.current_user_method(&:current_user)


          #config.authorize_with :cancan

        end


        # Basic config
        ([
            Article, Comment, Event, FormConfig, HomeAboutUsSlide, HomeContactInfo, HomeForm, HomePage, MainSliderSlide, User, Participant, TeamMember, Setting, Partner, AboutPageSliderSlide,
            EventTag, EventGalleryAlbum, EventGalleryImage, EventSubscription, UserFeedback,
            #ActsAsTaggableOn::Tag, ActsAsTaggableOn::Tagging
            HomePage, AboutPage, Pages::EventsList, Pages::ArticlesList, ContactPage, Pages::Students, Pages::Feedbacks, Pages::CoursesList,
            Message, Cms::MetaTags, Cms::SitemapElement


        ]#+(Dir.glob(Rails.root.join('app/models/pages/*.rb')).each {|file| require file;}; classes = [] ;Pages.constants.each {|c| classes.push("Pages::#{c.to_s}") }; classes )

        ).each do | model |
          #config.model model.name do
          #visible false
          config.included_models += [model]
          if model.respond_to?(:translates?) && model.translates? && model.respond_to?(:translation_class)
            config.included_models += ["#{model.translation_class}"]
          end
          #end
        end

        config.model Cms::Page do
          visible false
        end

        config.model_translation Cms::Page do
          visible false
        end


        config.model Cms::MetaTags do
          field :translations, :globalize_tabs
        end

        config.model_translation Cms::MetaTags do
          field :locale, :hidden
          field :title
          field :keywords
          field :description
        end

        config.model Pages::Students do
          pages_navigation_label
          initialize_model_label

          field :banner
          content_field(:students_text, :ck_editor)
          field :seo_tags
          field :sitemap_record
        end

        config.model Pages::Feedbacks do
          pages_navigation_label
          initialize_model_label

          field :banner
          field :seo_tags
          field :sitemap_record
        end



        # configure models
        config.model AboutPage do
          pages_navigation_label
          initialize_model_label
          field :banner
          field :top_text, :ck_editor
          field :quote
          field :about_page_slider_slides
          field :bottom_text, :ck_editor
          field :team_text, :ck_editor
          field :about_partners_text, :ck_editor
          field :seo_tags
          field :sitemap_record
        end

        config.include_models CallBack
        config.model CallBack do
          other_navigation_label
          initialize_model_label

        end

        config.include_models AboutPartner

        [[TeamMember, AboutPage], [AboutPartner, AboutPage], [Participant, Pages::Students]].each do |arr|
          m = arr.first
          parent_model = arr.second
          config.model m do
            nestable_list(position_field: :sorting_position)
            parent parent_model
            weight -1
            initialize_model_label

            field :published
            field :avatar
            field :translations, :globalize_tabs
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

          config.model_translation m do
            field :locale, :hidden
            field :name
            field :short_description
            field :avatar_alt
          end
        end


        config.model Cms::SitemapElement do
          edit do
            field :display_on_sitemap
            field :changefreq
            field :priority
          end
          # nested do
          #   field :display_on_sitemap
          #   field :changefreq
          #   field :priority
          # end

        end

	config.include_models PageAlias
	config.model PageAlias do
	  field :url
	  field :page  
	end
      end
    end
  end
end
