class Pages::EventsList < ActiveRecord::Base
  self.table_name = :pages_events_lists

  has_seo_tags

  image :banner, :styles => { :banner => '2100x500#'},
                    :url  => "/assets/#{self.name.underscore}/:id/banner/:style/:basename.:extension",
                    :path => ":rails_root/public/assets/#{self.name.underscore}/:id/banner/:style/:basename.:extension",
                    convert_options: {
                        banner: "-quality 94 -interlace Plane",
                    }

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
  end
end
