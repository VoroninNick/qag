class CreateAboutPageSliderSlides < ActiveRecord::Migration
  def up
    model = AboutPageSliderSlide

    create_table model.table_name do |t|
      t.string :name
      t.text :short_description
      t.text :full_description
      t.boolean :published
      t.integer :order_index

      t.string :background_file_name
      t.string :background_content_type
      t.integer :background_file_size
      t.datetime :background_updated_at
      t.string :background_file_name_fallback
      t.string :background_alt

      t.timestamps
    end

    model.create_translation_table!

    change_table model.translation_class.table_name do |t|
      t.boolean :published_translation
    end
  end

  def down
    model = AboutPageSliderSlide

    drop_table model.table_name

    model.drop_translation_table!
  end
end
