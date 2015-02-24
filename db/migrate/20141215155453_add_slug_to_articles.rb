class AddSlugToArticles < ActiveRecord::Migration
  def change
    add_column Article.table_name, :slug, :string
    add_column Article.translation_class.table_name, :slug, :string
  end
end
