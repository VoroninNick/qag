class AddFieldsToUser < ActiveRecord::Migration
  def change
    model = User

    change_table model.table_name do |t|
      t.string :status
      t.string :name
      t.string :role
    end

    model.create_translation_table!

    [:avatar].each do |field_name|
      change_table model.table_name do
        t.string "#{field_name.to_s}_file_name".to_sym
        t.string "#{field_name.to_s}_image_content_type".to_sym
        t.integer "#{field_name.to_s}_file_size".to_sym
        t.datetime "#{field_name.to_s}_updated_at".to_sym
        t.string "#{field_name.to_s}_file_name_fallback".to_sym
        t.string "#{field_name.to_s}_alt".to_sym
      end

      change_table model.translation_class.table_name do |t|
        t.string "#{field_name.to_s}_alt".to_sym
      end


    end
  end
end
