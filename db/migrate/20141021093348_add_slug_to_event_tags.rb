class AddSlugToEventTags < ActiveRecord::Migration
  def change
    model = EventTag

    add_column model.table_name, :slug, :string

    add_column model.translation_class.table_name, :slug, :string
  end
end
