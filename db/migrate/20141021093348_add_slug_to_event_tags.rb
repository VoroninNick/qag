class AddSlugToEventTags < ActiveRecord::Migration
  def change
    model = EventTag

    add_column model.table_name, :url_fragment, :string

    add_column model.translation_class.table_name, :url_fragment, :string
  end
end
