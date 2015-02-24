class CreateEventGalleryImages < ActiveRecord::Migration
  def up
    image_model = EventGalleryImage
    album_model = EventGalleryAlbum

    create_table album_model.table_name do |t|
      t.boolean :published
      t.string :name
      t.text :short_description

      t.has_attached_file :avatar
      t.string :avatar_alt
      t.string :avatar_file_name_fallback

      t.integer :order_index


    end

    album_model.create_translation_table!

    change_table album_model.translation_class.table_name do |t|
      t.boolean :published_translation
    end

    create_table image_model.table_name do |t|
      t.boolean :published
      t.has_attached_file :image
      t.string :image_alt
      t.string :image_file_name_fallback
      t.string :name
      t.text :short_description
      t.integer :order_index

      t.timestamps
    end

    image_model.create_translation_table!

    change_table image_model.translation_class.table_name do |t|
      t.boolean :published_translation
    end

    create_table :events_and_gallery_albums do |t|
      t.belongs_to :event
      t.belongs_to :event_gallery_album
    end

    create_table :event_gallery_albums_and_event_gallery_images do |t|
      t.belongs_to :event_gallery_album
      t.belongs_to :event_gallery_image
    end

    create_table :events_and_gallery_images do |t|
      t.belongs_to :event
      t.belongs_to :event_gallery_image
    end

  end

  def down
    image_model = EventGalleryImage
    album_model = EventGalleryAlbum

    drop_table album_model.table_name

    album_model.drop_translation_table!

    drop_table image_model.table_name

    image_model.drop_translation_table!

    drop_table :events_and_gallery_albums

    drop_table :event_gallery_albums_and_event_gallery_images

    drop_table :events_and_gallery_images
  end
end
