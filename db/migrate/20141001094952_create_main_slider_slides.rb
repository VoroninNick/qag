class CreateMainSliderSlides < ActiveRecord::Migration
  def up
    model = MainSliderSlide

    create_table model.table_name do |t|
      t.string :name
      t.text :short_description
      t.text :full_description
      t.boolean :published
      t.integer :order_index

      t.string :background_image_file_name
      t.string :background_image_content_type
      t.integer :background_image_file_size
      t.datetime :background_image_updated_at
      t.string :background_image_file_name_fallback
      t.string :background_image_alt

      t.timestamps
    end

    model.create_translation_table!

    change_table model.table_name do |t|
      t.boolean :published_translation
    end
  end

  def down
    model = MainSliderSlide

    drop_table model.table_name

    model.drop_translation_table!
  end
end
