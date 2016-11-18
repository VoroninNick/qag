class Pages::CoursesList < ActiveRecord::Base
  self.table_name = :pages_events_lists

  has_seo_tags
  has_sitemap_record

  image :banner, :styles => { :banner => '2100x500#'},
        :url  => "/assets/#{self.name.underscore}/:id/banner/:style/:basename.:extension",
        :path => ":rails_root/public/assets/#{self.name.underscore}/:id/banner/:style/:basename.:extension",
        convert_options: {
            banner: "-quality 94 -interlace Plane",
        }

  has_cache

  def url *args
    "/courses.html"
  end

  rails_admin do
    navigation_label I18n.t("rails_admin.navigation_labels.pages")
    label I18n.t("rails_admin.model_labels.#{self.abstract_model.model_name.underscore}")
    label_plural I18n.t("rails_admin.model_labels_plural.#{self.abstract_model.model_name.underscore}")

    field :banner do
      if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
        label asd
      end
    end

    field :seo_tags
    field :sitemap_record
  end
end
