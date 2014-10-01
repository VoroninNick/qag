class CreateEvents < ActiveRecord::Migration
  def up
    model = Event
    create_table model.table_name do |t|
      t.boolean :published
      t.string :name
      t.text :short_description
      t.text :full_description

      t.date :start_date
      t.date :end_date
      t.string :address
      t.integer :participants_count

      t.boolean :day_monday
      t.time :day_monday_start_time
      t.boolean :day_tuesday
      t.time :day_tuesday_start_time
      t.boolean :day_wensday
      t.time :day_wensday_start_time
      t.boolean :day_thursday
      t.time :day_thursday_start_time
      t.boolean :day_friday
      t.time :day_friday_start_time
      t.boolean :day_saturday
      t.time :day_saturday_start_time
      t.boolean :day_sunday
      t.time :day_sunday_start_time


      t.timestamps
    end

    model.create_translation_table!

    change_table model.table_name do |t|
      t.boolean :published_translation
    end

    [:avatar, :banner].each do |field_name|
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

  def down
    model = Event
    drop_table model.table_name

    model.drop_translation_table!
  end
end

