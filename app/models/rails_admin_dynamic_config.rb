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

def content_field(name = :content)
  field name, :text do
    help "Якщо редактор не відображається, обновіть сторінку"
    html_attributes do
      {
          class: "my-codemirror",
          mode: "slim"
      }
    end

    def value
      bindings[:object].send(name)
    end
  end
end

def ckeditor_field name = :content, &block
  field name, :ck_editor, &block
end

def initialize_model_label
  label I18n.t("rails_admin.model_labels.#{self.abstract_model.model_name.underscore}")
  label_plural I18n.t("rails_admin.model_labels_plural.#{self.abstract_model.model_name.underscore}")
end

def initialize_field_label
  if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
    label asd
  end
end

def pages_navigation_label
  navigation_label do
    I18n.t("admin.navigation_labels.pages")
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
            HomePage, AboutPage, Pages::EventsList, Pages::ArticlesList, ContactPage, Pages::Students, Pages::Feedbacks,
            Message, Cms::MetaTags


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

        config.model Cms::MetaTags do
          field :title
          field :keywords
          field :description
        end

        config.model Pages::Students do
          content_field(:students_text)
          field :seo_tags
        end

        config.model Pages::Feedbacks do
          field :seo_tags
        end


        # configure models
        config.model AboutPage do
          pages_navigation_label
          initialize_model_label
          field :banner do
            initialize_field_label
          end

          field :top_text, :ck_editor do
            initialize_field_label
          end
          field :quote do
            initialize_field_label
          end
          field :about_page_slider_slides do
            initialize_field_label
          end
          field :bottom_text, :ck_editor do
            initialize_field_label
          end
          field :team_text, :ck_editor do
            initialize_field_label
          end
          field :team_members do
            initialize_field_label
          end
          field :participants_text, :ck_editor do
            initialize_field_label
          end
          field :participants do
            initialize_field_label
          end
          field :seo_tags
        end
      end
    end
  end
end