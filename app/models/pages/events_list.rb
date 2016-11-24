class Pages::EventsList < ActiveRecord::Base
  self.table_name = :pages_events_lists

  has_seo_tags
  has_sitemap_record

  image :banner, :styles => { :banner => '2100x500#'},
                    :url  => "/uploads/#{self.name.underscore}/:id/banner/:style/:basename.:extension",
                    :path => ":rails_root/public:url",
                    convert_options: {
                        banner: "-quality 94 -interlace Plane",
                    }

  has_cache

  def url *args
    "/events.html"
  end

  rails_admin do
    navigation_label I18n.t("rails_admin.navigation_labels.pages")
    initialize_model_label

    field :banner do
      initialize_field_label
    end

    field :seo_tags
    field :sitemap_record
  end
end
