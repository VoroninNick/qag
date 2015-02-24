class CreateVoroninStudioPageMetadata < ActiveRecord::Migration
  def up
    model = VoroninStudio::PageMetadata
    create_table model.table_name do |t|
      t.string :head_title
      t.text :meta_tags
      t.text :meta_description

      # columns for belongs_to :page, polymorphic: true
      t.integer :page_id
      t.string :page_type
      t.timestamps
    end
    model.create_translation_table!({head_title: :string, meta_tags: :text, meta_description: :text })
  end
  def down
    model = VoroninStudio::PageMetadata
    drop_table model.table_name
    model.drop_translation_table!
  end
end
