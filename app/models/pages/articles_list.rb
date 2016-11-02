class Pages::ArticlesList < ActiveRecord::Base
  self.table_name = :pages_articles_lists

  has_seo_tags

  image :banner, :styles => { :banner => '2100x500#'},
                    :url  => "/assets/#{self.name.underscore}/:id/banner/:style/:basename.:extension",
                    :path => ":rails_root/public/assets/#{self.name.underscore}/:id/banner/:style/:basename.:extension",
                    convert_options: {
                        banner: "-quality 94 -interlace Plane",
                    }


  def url(*args)
    "/articles.html"
  end
  rails_admin do
    pages_navigation_label
    label I18n.t("rails_admin.model_labels.#{self.abstract_model.model_name.underscore}")
    label_plural I18n.t("rails_admin.model_labels_plural.#{self.abstract_model.model_name.underscore}")

    field :banner do
      if asd = I18n.t("rails_admin.field_labels.#{method_name}", raise: true) rescue false
        label asd
      end
    end

    field :seo_tags
  end
end
