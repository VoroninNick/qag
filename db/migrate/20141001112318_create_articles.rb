class CreateArticles < ActiveRecord::Migration
  def up
    model = Article
    create_table model.table_name do |t|
      t.boolean :published
      t.string :name
      t.text :short_description
      t.text :full_description

      t.date :release_date

      t.timestamps
    end

    [:avatar, :banner].each do |field_name|
      change_table model.table_name do |t|
        t.string "#{field_name.to_s}_file_name".to_sym
        t.string "#{field_name.to_s}_image_content_type".to_sym
        t.integer "#{field_name.to_s}_file_size".to_sym
        t.datetime "#{field_name.to_s}_updated_at".to_sym
        t.string "#{field_name.to_s}_file_name_fallback".to_sym
        t.string "#{field_name.to_s}_alt".to_sym
      end
    end

    model.create_translation_table!

    change_table model.translation_class.table_name do |t|
      t.boolean :published_translation
    end
  end

  def down
    model = Article
    drop_table model.table_name

    model.drop_translation_table!
  end
end
