class AddFieldsToUser < ActiveRecord::Migration
  def up
    model = User

    change_table model.table_name do |t|
      t.string :status
      t.string :name
      t.string :role
    end

    [:avatar].each do |field_name|
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

  end

  def down
    model = User

    remove_column model.table_name, :status
    remove_column model.table_name, :name
    remove_column model.table_name, :role

    [:avatar].each do |field_name|
        remove_column model.table_name, "#{field_name.to_s}_file_name".to_sym
        remove_column model.table_name, "#{field_name.to_s}_image_content_type".to_sym
        remove_column model.table_name, "#{field_name.to_s}_file_size".to_sym
        remove_column model.table_name, "#{field_name.to_s}_updated_at".to_sym
        remove_column model.table_name, "#{field_name.to_s}_file_name_fallback".to_sym
        remove_column model.table_name, "#{field_name.to_s}_alt".to_sym
    end

    model.drop_translation_table!
  end
end
