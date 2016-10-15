class CreatePageTranslations < ActiveRecord::Migration
  def up
    if !table_exists?(Cms::Page.translation_class.table_name)
      Cms::Page.initialize_globalize
      Cms::Page.create_translation_table!(url: :string, content: :text, name: :string)
    end
  end

  def down
    if table_exists?(Cms::Page.translation_class.table_name)
      Cms::Page.drop_translation_table!
    end
  end
end
