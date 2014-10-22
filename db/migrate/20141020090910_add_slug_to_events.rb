class AddSlugToEvents < ActiveRecord::Migration
  def change
    add_column Event.table_name, :slug, :string

    add_column Event.translation_class.table_name, :slug, :string
  end
end
