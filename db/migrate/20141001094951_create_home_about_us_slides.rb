class CreateHomeAboutUsSlides < ActiveRecord::Migration
  def up
    model = HomeAboutUsSlide

    create_table model.table_name do |t|
      t.string :name
      t.text :short_description
      t.text :full_description
      t.boolean :published
      t.integer :order_index

      t.belongs_to :home_page

      t.timestamps
    end

    model.create_translation_table!

    change_table model.translation_class.table_name do |t|
      t.boolean :published_translation
    end
  end

  def down
    model = HomeAboutUsSlide

    drop_table model.table_name

    model.drop_translation_table!
  end
end
