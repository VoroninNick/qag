class AddSlugToArticles < ActiveRecord::Migration
  def change
    add_column Article.table_name, :url_fragment, :string
    add_column Article.translation_class.table_name, :url_fragment, :string
  end
end
