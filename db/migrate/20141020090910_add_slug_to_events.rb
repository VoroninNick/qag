class AddSlugToEvents < ActiveRecord::Migration
  def change
    add_column Event.table_name, :url_fragment, :string

    add_column Event.translation_class.table_name, :url_fragment, :string
  end
end
